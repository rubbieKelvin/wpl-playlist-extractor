from PySide2.QtCore import Property, Slot, Signal, QObject
from . import reader
import os, json, threading

class WPLExtractor(QObject):
	"""docstring for PluginOne."""
	def __init__(self):
		super(WPLExtractor, self).__init__()
		self.root = None
		self.musics = None

	errorOccured = Signal(str)
	wplParsed = Signal(str)
	extractEnabledChanged = Signal(bool)
	extractionStarted = Signal()
	extractionEnded = Signal()
	progressChanged = Signal(int)

	@Property(bool, notify=extractEnabledChanged)
	def extractenabled(self):
		return (self.root is not None and self.musics is not None)

	@Slot(str)
	def read_wpl(self, file):
		file = file[8:]
		response = reader.parsewpl(file)
		if response["error"] is not None:
			self.errorOccured.emit(response["error"])
		else:
			self.root = response["root"]
			self.musics = response["musics"]
			self.extractEnabledChanged.emit(True)
			songs = []
			for x in response["musics"]:
				x_ = os.path.splitext(x)
				songs.append({"name":x_[0], "ext":x_[1].strip(".")})
			self.wplParsed.emit(json.dumps(songs))

	@Slot(str)
	def extract(self, folder):
		folder = folder[8:]
		def extract_(self, folder):
			all = len(self.musics)
			n = 0
			for x in self.musics:
				try:
					with open(os.path.join(self.root, x), "rb") as file:
						cont = file.read()
					with open(os.path.join(folder, os.path.split(x)[-1]), "wb") as file:
						file.write(cont)
				except FileNotFoundError as e:
					pass
				n += 1
				prg = (n/all)*100
				self.progressChanged.emit(prg)
			self.extractionEnded.emit()
		self.extractionStarted.emit()
		threading.Thread(target=extract_, args=(self, folder)).start()
