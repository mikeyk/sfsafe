import math

""" Originally based on 
	http://stackoverflow.com/questions/238260/how-to-calculate-the-bounding-box-for-a-given-lat-lng-location

"""

# degrees to radians
def deg2rad(degrees):
    return math.pi*degrees/180.0
# radians to degrees
def rad2deg(radians):
    return 180.0*radians/math.pi

# Semi-axes of WGS-84 geoidal reference
WGS84_a = 6378137.0  # Major semiaxis [m]
WGS84_b = 6356752.3  # Minor semiaxis [m]

# Earth radius at a given latitude, according to the WGS-84 ellipsoid [m]
def WGS84EarthRadius(lat):
    # http://en.wikipedia.org/wiki/Earth_radius
    An = WGS84_a*WGS84_a * math.cos(lat)
    Bn = WGS84_b*WGS84_b * math.sin(lat)
    Ad = WGS84_a * math.cos(lat)
    Bd = WGS84_b * math.sin(lat)
    return math.sqrt( (An*An + Bn*Bn)/(Ad*Ad + Bd*Bd) )

class BoundingBox(object):
	"""docstring for BoundingBox"""
	def __init__(self, lat, lon, half_side_in_km=0.5):
		super(BoundingBox, self).__init__()
		self.lat_in_degrees = lat
		self.lon_in_degrees = lon

	# Bounding box surrounding the point at given coordinates,
	# assuming local approximation of Earth surface as a sphere
	# of radius given by WGS84
	def getBox(self, half_side_in_km):
	    lat = deg2rad(self.lat_in_degrees)
	    lon = deg2rad(self.lon_in_degrees)
	    half_side= 1000*half_side_in_km

	    # Radius of Earth at given latitude
	    radius = WGS84EarthRadius(lat)
	    # Radius of the parallel at given latitude
	    pradius = radius*math.cos(lat)

	    latMin = lat - half_side/radius
	    latMax = lat + half_side/radius
	    lonMin = lon - half_side/pradius
	    lonMax = lon + half_side/pradius

	    return (rad2deg(latMin), rad2deg(lonMin), rad2deg(latMax), rad2deg(lonMax))