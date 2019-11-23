import os
import xml.etree.ElementTree as ET

def parsewpl(filename):
	# prepare result frame
	res = dict(
		root=os.path.split(filename)[0],
		musics=[],
		error=None,
		generator=[]
	)

	# make sure file is available or parsing is successful
	try:
		tree = ET.parse(filename)
		root = tree.getroot()
		if root.tag == "smil" and len(root) > 1:
			head = root[0]
			body = root[1]

			# parse head
			for child in head:
				if child.tag == "meta" and "name" in child.attrib and "content" in child.attrib:
					if child.attrib["name"].lower() == "generator":
						res["generator"] = child.attrib["content"]

			# parse body
			if len(body) > 0:
				if body[0].tag == "seq":
					seq = body[0]

					for child in seq:
						if child.tag == "media":
							res["musics"].append(child.attrib["src"])
				else:
					res["error"] = "couldnt read file. unknown error"
		else:
			res["error"] = "document root is not 'smil'"
	except (ET.ParseError, FileNotFoundError) as e:
		res["error"] = "error parsing file"

	return res
