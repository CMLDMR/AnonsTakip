import QtQuick 2.11
import QtQuick.Controls 2.4

import com.mongodb 0.7

Item {

    id: item
    anchors.fill: parent

    property string mesaj: ""


    Rectangle {
        id: toprect
        width: 0
        height: parent.height
        color: "#CC000000"
        clip: true
        MouseArea{
            anchors.fill: parent
        }


        Rectangle {
            width: parent.width
            height: 150
            color: "white"
            anchors.centerIn: parent

            Column{
                anchors.fill: parent
                Rectangle {
                    width: parent.width
                    height: 100
                    color: "white"
                    Text {
                        text: mesaj
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "black"
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "DarkSlateGray"
                    Text {
                        text: qsTr("Tamam")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            closeDialog.start();
                        }
                    }
                }

            }




        }

    }


    PropertyAnimation{
        id: openDialog
        target: toprect
        property: "width"
        to: item.width
        duration: 250
        onStarted: {
            item.visible = true;
        }
    }

    PropertyAnimation{
        id: closeDialog
        target: toprect
        property: "width"
        to: 0
        duration: 250
        onStopped: {
            item.visible = false;
        }
    }


    function open(mesajText){
        mesaj = mesajText;
        openDialog.start();
    }

    function close(){
        closeDialog.start();
    }


}
