import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.9
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.0
import "src/qml"
import "src/js/app.js" as App
import Qt.labs.platform 1.1

ApplicationWindow{
	id: root
	width: 500
	height: 600
	title: qsTr('Wpl Reader')
	visible: true

	signal wplParsed(string wpldata);
	signal errorOccured(string error);
	signal progressChanged(int progress)

	// once the app window is created...
	Component.onCompleted: {
		console.log("app stated");
		wpl.wplParsed.connect(wplParsed);
		wpl.errorOccured.connect(errorOccured);
		wpl.progressChanged.connect(progressChanged);
	}

	Connections {
	    target: root
	    onWplParsed: {
			stackLayout.currentIndex = 0;
			let data = JSON.parse(wpldata);
			wplmodel.clear();
			for (let i=0; i<data.length; i++){
				wplmodel.append({i_name:data[i].name, i_ext:data[i].ext})
			}
		}

		onErrorOccured:{
			stackLayout.currentIndex = 1;
			label.text = error;
		}

		onProgressChanged:{
			extractionprogress.value = progress
		}
	}

	// stack layout
	StackLayout {
		id: main
		currentIndex: 0
		anchors.fill: parent

		Page {
			width: parent.width
			height: parent.height
			enabled: (main.currentIndex == 0)

			Rectangle {
				id: rectangle
				anchors.fill: parent
				color: "#ffffff"


				TextField {
					id: textField
					y: 26
					height: 47
					text: wplfiledia.file
					anchors.right: parent.right
					anchors.rightMargin: 25
					anchors.left: parent.left
					anchors.leftMargin: 25
					placeholderText: "Click to pick .wpl file..."
					leftPadding: 10
					Layout.fillHeight: true
					Layout.fillWidth: true
					Layout.preferredHeight: 46
					Layout.preferredWidth: 291
					bottomPadding: 8
					font.pointSize: 9
					font.family: "Montserrat"
					background: Rectangle{
						radius: 4
						color: "#efefef"
					}

					onTextChanged: {
						wpl.read_wpl(text)
					}

					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						hoverEnabled: true
						onEntered: {}
						onExited: {}
						onClicked: {
							wplfiledia.open()
						}
					}
				}

				StackLayout {
					id: stackLayout
					currentIndex: 1
					anchors.top: parent.top
					anchors.topMargin: 96
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 8
					anchors.right: parent.right
					anchors.rightMargin: 25
					anchors.left: parent.left
					anchors.leftMargin: 25

					Page {
						id: previewpage
						width: parent.width
						height: parent.height
						Rectangle{
							color: "#ffffff"
							width: parent.width
							height: parent.height

							ScrollView {
								id: scrollView
								clip: true
								anchors.fill: parent

								ListView {
									id: listView
									anchors.fill: parent
									delegate: MusicItem{
										id: item_root
										width: parent.width
										name: i_name
										ext: i_ext
									}
									model: ListModel {
										id: wplmodel
									}
								}
							}
						}
					}

					Page {
						id: errorpage
						width: parent.width
						height: parent.height
						Rectangle{
							id: rectangle1
							color: "#ffffff"
							width: parent.width
							height: parent.height

							Image {
								id: image
								x: 175
								y: 144
								anchors.horizontalCenter: parent.horizontalCenter
								source: "res/images/error.png"
								fillMode: Image.PreserveAspectFit
							}

							Label {
								id: label
								x: 208
								y: 244
								width: 378
								height: 17
								color: "#dea9a9a9"
								text: qsTr("Choose a wpl file")
								font.capitalization: Font.Capitalize
								font.family: "Montserrat"
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignHCenter
								anchors.horizontalCenter: parent.horizontalCenter
							}
						}
					}
				}
				RoundButton {
					id: roundButton
					x: 414
					y: 545
					width: 78
					height: 47
					text: "extract"
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 8
					anchors.right: parent.right
					anchors.rightMargin: 8
					font.pointSize: 7
					font.family: "Montserrat"
					Material.foreground: "#ffffff"
					Material.background: Material.accent
					enabled: wpl.extractenabled

					onClicked:{
						exctractionFolder.open()
					}
				}

    ProgressBar {
        id: extractionprogress
		y: 596
		to: 100
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
  anchors.bottomMargin: 0
		value: 0
	}
			}
		}
	}

	FileDialog{
		id: wplfiledia
		folder: StandardPaths.writableLocation(StandardPaths.DocumentLocation)
		title: "Select wpl file"
		nameFilters: "Wpl Files (*.wpl)"
	}

	FolderDialog{
		id: exctractionFolder
		currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentLocation)
		title: "Select Folder"

		onAccepted: {
			wpl.extract(folder);
		}
	}
}





/*##^## Designer {
    D{i:7;anchors_height:496;anchors_width:450;anchors_x:25;anchors_y:96}D{i:6;anchors_height:100;anchors_width:100}
D{i:11;anchors_height:160;anchors_width:110;anchors_x:0;anchors_y:0}D{i:10;anchors_height:200;anchors_width:200}
D{i:20;anchors_x:8}D{i:4;anchors_x:25}
}
 ##^##*/
