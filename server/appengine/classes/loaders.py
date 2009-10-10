from datetime import datetime
from google.appengine.ext import db
from google.appengine.tools import bulkloader
from classes import models

class CrimeEntryLoader(bulkloader.Loader):
  def __init__(self):
	bulkloader.Loader.__init__(self, 'CrimeEntry',
							   [('category', str),
								('description', str),
								('incident', str),
								('resolution', str),
								('timestamp', lambda x: datetime.utcfromtimestamp(float(x))),
								('lat', float),
								('lon', float),
								('district', str),
								('geoboxes', lambda x: eval(x)),
								('neighborhood', str)
							   ])

loaders = [CrimeEntryLoader]