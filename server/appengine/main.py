#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

from classes.models import *
import wsgiref.handlers
from django.utils import simplejson
from django.core import serializers
from datetime import datetime, timedelta
import time
import logging



from google.appengine.ext import webapp

def output_json_results(results):
	
	entries = []
	filtered = 0

	left_most = None
	right_most = None
	top_most = None
	bottom_most = None
	
	for result in results:
		entry = result[1]
		# TODO put date filter back
		# if entry.timestamp >= min_time:
		entry_dict = {}
		for x in ['incident', 'category', 'description', 'lat', 'lon']:
			entry_dict[x] = getattr(entry,x)
		entry_dict['timestamp'] = time.mktime(getattr(entry, 'timestamp').timetuple())

		if not left_most or entry_dict['lon'] < left_most:
			left_most = entry_dict['lon']
		if not right_most or entry_dict['lon'] > right_most:
			right_most = entry_dict['lon']
		if not top_most or entry_dict['lat'] > top_most:
			top_most = entry_dict['lat']
		if not bottom_most or entry_dict['lat'] < bottom_most:
			bottom_most = entry_dict['lat']
	
	
		entries.append(entry_dict)

	lat_delta = None
	lon_delta = None

	if len(entries) > 0:
		lat_delta = abs(top_most - bottom_most)
		lon_delta = abs(left_most - right_most)

	rv = {
		'result_set': entries,
		'num_results':len(entries),
		'discarded': filtered,
		'latitude_delta': lat_delta,
		'longitude_delta': lon_delta
	}

	logging.debug(rv)
	return simplejson.dumps(rv)


class NeighborhoodHandler(webapp.RequestHandler):
	
	def get(self):
		if not self.request.get("n"):
			self.response.out.write(simplejson.dumps({'error':"wrong params"}))
		else:
			neighborhood = self.request.get("n")
			results = CrimeEntry.by_neighborhood(neighborhood)
			
			self.response.out.write(output_json_results(results))
		

class NearbyHandler(webapp.RequestHandler):

	def get(self):
		if not self.request.get("lat") or not self.request.get("lon"):
			self.response.out.write(simplejson.dumps({'error':"wrong params"}))
		else:
			lat = float(self.request.get("lat"))
			lon = float(self.request.get("lon"))
			logging.debug("Lat/lon search: %s %s" % (lat, lon))
		
			boxheight = float(self.request.get("boxheight"))
			boxwidth = float(self.request.get("boxwidth"))
		
			numdays = int(self.request.get("days", 90))

			delta = timedelta(numdays)
			min_time = datetime.utcnow() - delta
		
			results = CrimeEntry.query(lat, lon, 50, (2,0))

			self.response.out.write(output_json_results(results))

def main():
	logging.getLogger().setLevel(logging.DEBUG)
	application = webapp.WSGIApplication(
		[
			('/nearby', NearbyHandler),
			('/neighborhood', NeighborhoodHandler)
		],
	 	debug=True)
	wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
