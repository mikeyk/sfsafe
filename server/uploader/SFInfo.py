from xml.dom import minidom
from datetime import datetime
import time
# from geohash import Geoindex
from csv import DictWriter
import urllib
import calendar
import geobox
import plistlib

# List of resolutions and slices. Should be in increasing order of size/scope.
GEOBOX_CONFIGS = (
  (4, 5, True),
  (3, 2, True),
  (3, 8, False),
  (3, 16, False),
  (2, 5, False),
)

class Point(object):
	def __init__(self, lat, lon):
		self.lat = lat
		self.lon = lon
		
	def __repr__(self):
		return "lat: %s lon %s" % (self.lat, self.lon)

class Bounds(object):
	
	def __init__(self, north, east, south, west):
		self.north = north
		self.east = east
		self.south = south
		self.west = west
		
	def contains(self, point):
		if ((point.lat < self.west) and (point.lat > self.east) and
			(point.lon < self.south) and (point.lon > self.north)):
			return True
		else:
			return False
		
	def __repr__(self):
		return 'N: %s E: %s S: %s W: %s' % (self.north, self.east, self.south, self.west)

class Neighborhood(object):
	
	def __init__(self, name, points, center):
		self.points = points
		self.name = name
		self.bounds = self.generatebounds()
		self.center = center

	def contains(self, point):
		
		num_points = len(self.points)
		in_poly = False
		j = num_points - 1
		for i in range(0, num_points):
			v1 = self.points[i]
			v2 = self.points[j]
			
			if (v1.lon < point.lon and v2.lon >= point.lon) or (v2.lon < point.lon and v1.lon >= point.lon):
				if (v1.lat + (point.lon - v1.lon)/ (v2.lon - v1.lon) * (v2.lat - v1.lat) < point.lat):
					in_poly = not in_poly
			j = i
		return in_poly
		
	def generatebounds(self):
		# top right
		lats = [x.lat for x in self.points]
		lons = [x.lon for x in self.points]
		return Bounds(min(lons), min(lats), max(lons), max(lats))
		
	
	def __repr__(self):
		return '%s %s' % (self.name, self.bounds)

def find_neighborhood(point):
	found_hoods = 0
	for neighborhood in neighborhoods:
		# rough matching first
		if neighborhood.bounds.contains(point):
			# now fine tune
			if neighborhood.contains(point):
				return neighborhood.name
				
def kml_to_csv(neighborhoods, district, data, writer, min_timestamp):

	parsetree = minidom.parseString(data)

	placemarks = parsetree.getElementsByTagName("Placemark")
	for place in placemarks:
		try:
			
			description = place.getElementsByTagName('description')
			extended_data = {}
			all_info = {}
			extended_data_nodes = place.getElementsByTagName('SimpleData')
			for entry in extended_data_nodes:
				entry_name = entry.getAttribute("name")
				entry_val = entry.firstChild
				extended_data[entry_name.lower()] = entry_val.data
				
			date = time.strptime(extended_data["date"] + ' ' + extended_data["time"], "%m/%d/%Y %H:%M")
			if time.mktime(date) < min_timestamp:
				continue

			for entry_name in ['category', 'description', 'incident', 'resolution']:
				all_info[entry_name] = extended_data[entry_name]
			

			# print date
			all_info["timestamp"] = time.mktime(date)
	
			location_node = place.getElementsByTagName('Point')[0].getElementsByTagName('coordinates')[0].firstChild.data
			lon = float(location_node.split(',')[0])
			lat = float(location_node.split(',')[1])
		
			all_info["lon"] = lon
			all_info["lat"] = lat
			all_info["district"] = district

			all_boxes = []
			for (resolution, slice, use_set) in GEOBOX_CONFIGS:
			  if use_set:
				all_boxes.extend(geobox.compute_set(lat, lon, resolution, slice))
			  else:
				all_boxes.append(geobox.compute(lat, lon, resolution, slice))
			
			all_info["geoboxes"] = all_boxes
			
			all_info["neighborhood"] = find_neighborhood(Point(lat,lon))

			writer.writerow(all_info)
		except Exception, e:
			print e

def correct_neighborhood_name(name):
	corrections = {
		'Jordan Park / Laurel Heights' : 'Laurel Heights',
		'Inner Sunset' : 'Sunset, Inner',
		'Outer Sunset' : 'Sunset, Outer',
		'Outer Richmond' : 'Richmond, Outer',
		'Inner Richmond': 'Richmond, Inner',
		'Central Richmond' : 'Richmond, Central',
		'Central Sunset' : 'Sunset, Central',
		'Outer Parkside' : 'Parkside, Outer',
		'Inner Parkside': 'Parkside, Inner',
		'Inner Mission' : 'Mission, Inner',
		'Outer Mission' : 'Mission, Outer',
		'Lower Pacfic Heights' : 'Pacific Heights, Lower',
		'North Panhandle' : 'Panhandle, North',
	}
	return corrections.get(name, name)
	
		
def parse_neighborhoods(fl):
	parsetree = minidom.parseString(fl)	
	placemarks = parsetree.getElementsByTagName("Placemark")
	neighborhoods = list()
	for placemark in placemarks:

		name_node = placemark.getElementsByTagName('ExtendedData')[0]
		for datanode in name_node.getElementsByTagName('Data'):
			if datanode.getAttribute('name') == 'NBRHOOD':
				neighborhood_name = datanode.getElementsByTagName('value')[0].firstChild.data
				neighborhood_name = correct_neighborhood_name(neighborhood_name)
		raw_points = placemark.getElementsByTagName('Polygon')[0].getElementsByTagName('coordinates')[0].firstChild.data.split()
		point_tuples = list()
		for point in raw_points:
			point_tuple = point.split(',')
			p = Point(float(point_tuple[1]), float(point_tuple[0]))
			point_tuples.append(p)
			
		center_coords = placemark.getElementsByTagName('Point')[0].getElementsByTagName('coordinates')[0].firstChild.data.split(",")
		center = Point(float(center_coords[1]), float(center_coords[0]))
		n = Neighborhood(neighborhood_name, point_tuples, center)
		neighborhoods.append(n)
	
	return neighborhoods
	
def print_neighborhood_plist(neighborhoods):
	print plistlib.writePlistToString([{
							'name': x.name, 
							'lat': x.center.lat, 
							'lon': x.center.lon} for x in neighborhoods])

if __name__ == '__main__':
	neighborhood_fl = open("neighborhoods.kml").read()
	neighborhoods = parse_neighborhoods(neighborhood_fl)
	
	print_neighborhood_plist(neighborhoods)
	# in last 2 months...
	5/0
	min_ts = time.time() - 60 * 24 * 60 * 60
	writer = DictWriter(open('../parseddata/out-all.csv', 'wb'), ['category', 'description', 'incident', 'resolution', 'timestamp', 'lat', 'lon', 'district', 'geoboxes', 'neighborhood'])
	for district in ["Bayview", "Central", "Ingleside", 
					"Mission", "Northern",
					"Park", "Richmond", "Southern", "Taraval", 
					"Tenderloin"]:
	# for district in ["Mission"]:
	
		# data = urllib.urlopen("http://apps.sfgov.org/datafiles/view.php?file=Police/CrimeIncident90%s.kml" % district).read()
		# print "fetching ", district
		# outfl = open("../data/%s.kml" % district, "w")
		# outfl.write(data)
		# outfl.close()
		infl = open("../data/%s.kml" % district).read()
		
		kml_to_csv(neighborhoods, district, infl, writer, min_ts)
	# data = open("../data/tenderloin.kml.xml")
		