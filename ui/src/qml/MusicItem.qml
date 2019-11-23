import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.9
import QtQuick.Controls.Material 2.0

Rectangle {
	id: root
	width: 450
	height: 60

	property string name
	property string ext

	Rectangle {
		id: rect
		y: 4
		width: 50
		height: 50
		color: (ext==="mp3")?"#e91e63":(ext==="wma")?"#2196f3":(ext==="ogg")?"#689f38":"#757575"
		radius: 4
		anchors.left: parent.left
		anchors.leftMargin: 8

		Label {
			color: "#deffffff"
			text: ext
			font.capitalization: Font.AllUppercase
			font.weight: Font.Medium
			font.pointSize: 9
			font.family: "Montserrat"
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
			anchors.fill: parent
		}
	}

	Label {
		y: 4
		height: 48
		text: name
		font.capitalization: Font.Capitalize
		font.family: "Montserrat"
		anchors.right: parent.right
		anchors.rightMargin: 45
		anchors.left: rect.right
		anchors.leftMargin: 13
		verticalAlignment: Text.AlignVCenter
	}

}



/*##^## Designer {
    D{i:1;anchors_x:8}D{i:3;anchors_width:334;anchors_x:71}
}
 ##^##*/
