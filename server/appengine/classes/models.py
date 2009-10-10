#!/usr/bin/env python

# parts adapted from Brett Slatkin's mutiny application, 
# under the Apache License

from google.appengine.ext import db
import math
import geobox
import logging

logging.debug("test")
""".

In San Francisco, the degrees of latitude and longitude roughly translate into
these distances on the ground:

0.00001 = 1 meters = 3.2 feet
0.0001 = 10 meters = 32 feet
0.0002 = 20 meters = 65 feet
0.0005 = 50 meters = 165 feet
0.001 = 100 meters = 330 feet
0.002 = 200 meters = 660 feet = 0.125 miles
0.005 = 500 meters = 1,640 feet = 0.3 miles
0.008 = 800 meters = 2,625 feet = 0.5 miles
0.016 = 1600 meters = 5,250 feet = 1.0 miles
0.05 = 5000 meters = 16,400 feet = 3.1 miles

We'll use all of these various resolutions to allow for scanning for bus stops
at different levels of resolution.
"""


# List of resolutions and slices. Should be in increasing order of size/scope.
GEOBOX_CONFIGS = (
  (4, 5, True),
  (3, 2, True),
  (3, 8, False),
  (3, 16, False),
  (2, 5, False),
)

# Radius of the earth in miles.
RADIUS = 3963.1676


def _earth_distance(lat1, lon1, lat2, lon2):
  lat1, lon1 = math.radians(float(lat1)), math.radians(float(lon1))
  lat2, lon2 = math.radians(float(lat2)), math.radians(float(lon2))
  return RADIUS * math.acos(math.sin(lat1) * math.sin(lat2) +
	  math.cos(lat1) * math.cos(lat2) * math.cos(lon2 - lon1))

class CrimeEntry(db.Model):
	geohash = db.StringProperty()
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	category = db.StringProperty()
	timestamp = db.DateTimeProperty()
	description = db.StringProperty()
	incident = db.StringProperty()	
	resolution = db.StringProperty()
	geoboxes = db.StringListProperty()
	neighborhood = db.StringProperty()
	
	@classmethod
	def _incidents_by_distance(cls, lat, lon, incidents):
		incidents_by_distance = []
		for incident in incidents.itervalues():
			distance = _earth_distance(lat, lon, incident.lat, incident.lon)
			incidents_by_distance.append((distance, incident))
		incidents_by_distance.sort()
		return incidents_by_distance

	
	@classmethod
	def by_neighborhood(cls, neighborhood, max_results=250):
		found_incidents = {}
		query = cls.all()
		query.filter("neighborhood =", neighborhood)
		results = query.fetch(max_results)
		return [(0, incident) for incident in results]

	

	@classmethod
	def query(cls, lat, lon, max_results, min_params):
		"""Queries for incidents repeatedly until max results or scope is reached.
		Args:
		  lat, lon: Coordinates of the agent querying.
		  max_results: Maximum number of stops to find.
		  min_params: Tuple (resolution, slice) of the minimum resolution to allow.

		Returns:
		  List of (distance, CrimeEntry) tuples, ordered by minimum distance first.
		  There will be no duplicates in these results. Distance is in meters.
		"""
		# Maps stop_ids to CrimeEntry instances.
		found_incidents = {}

		# Do concentric queries until the max number of results is reached.
		# Use only the first three geoboxes for search to reduce query overhead.
		for params in GEOBOX_CONFIGS[:3]:
			if len(found_incidents) >= max_results:
			  break
			if params < min_params:
			  break
        
			resolution, slice, unused = params
			box = geobox.compute(lat, lon, resolution, slice)
			logging.debug("Searching for box=%s at resolution=%s, slice=%s",
			  			box, resolution, slice)
			query = cls.all()
			query.filter("geoboxes =", box)
			results = query.fetch(50)
			# logging.debug("Found %d results", len(results))
        
			# De-dupe results.
			for result in results:
				if result.incident not in found_incidents:
					found_incidents[result.incident] = result
        
		# Now compute distances and sort by distance.
		return cls._incidents_by_distance(lat, lon, found_incidents)