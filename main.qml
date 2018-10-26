import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4

import QtLocation 5.6
import QtPositioning 5.6

import com.mongodb 0.7

Window {
    id: root
    visible: true
    width: 360
    height: 640
    title: qsTr("Anons Takip - Serik Belediyesi - Bilgi İşlem Müdürlüğü 2018")





    Rectangle {
        id: maprect
        width: parent.width
        height: 250
        color: "white"
        anchors.top: parent.top

        Plugin {
            id: mapPlugin
            name: "osm" // "mapboxgl", "esri", "osm" ...
            // specify plugin parameters if necessary
            // PluginParameter {
            //     name:
            //     value:
            // }
            locales: ["tr_TR","en_US"]
        }

        Map {
            id: map
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(36.91577, 31.10379) // Serik Belediye Binası
            zoomLevel: 15

            Rectangle {
                width: 10
                height: 10
                color: "DarkRed"
                radius: 5
                anchors.centerIn: parent
            }

        }
    }

    Rectangle {
        width: parent.width
        height: 50
        color: "white"
        anchors.top: maprect.bottom
        Text {
            text: qsTr("Anons Cihaz Listesi")
            font.bold: true
            font.pointSize: 10
            font.family: "Tahoma"
            color: "Gray"
            anchors.centerIn: parent
        }
    }



    ScrollView{
        id: scroller
        anchors.fill: parent
        anchors.topMargin: 300
        anchors.bottomMargin: 50
        clip: true

        Column{
            anchors.fill: parent
            spacing: 5

            Repeater{
                id: repeater
                Rectangle {
                    width: scroller.width
                    height: 50
                    color: "DarkSlateGray"

                    Row{
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width/4*3
                            height: parent.height
                            color: "transparent"

                            Text {
                                text: modelData.getElement("cihazadi").String
                                font.bold: true
                                font.pointSize: 10
                                font.family: "Tahoma"
                                color: "white"
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    loadDevice(modelData.getElement("_id").Oid);
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width/4
                            height: parent.height
                            color: "DarkGray"
                            Text {
                                text: qsTr("Konum Göster")
                                font.bold: true
                                font.pointSize: 10
                                font.family: "Tahoma"
                                color: "white"
                                anchors.centerIn: parent
                                width: parent.width
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {

                                    var filter = QBSON.newBSON();

                                    filter.addOid("_id",modelData.getElement("_id").Oid);

                                    var dev = db.find_one("AnonsCihazlari",filter,QBSON.newBSON());


                                    map.center = QtPositioning.coordinate(dev.getElement("latitute").Double,dev.getElement("longtitude").Double);
                                    map.zoomLevel = 16;

                                }
                            }


                        }


                    }


                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 50
        color: "DarkSlateBlue"
        anchors.bottom: parent.bottom
        Text {
            text: qsTr("Yeni Ekle+")
            font.bold: true
            font.pointSize: 10
            font.family: "Tahoma"
            color: "white"
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {

                var com = Qt.createComponent("qrc:/qmlsrc/AddNewDevice.qml");

                if( com.status === Component.Ready )
                {
                    var e = com.createObject(root);

                    e.added.connect(function(){
                        e.destroy();
                        repeater.model = db.find(DBKey.collection,QBSON.newBSON(),QBSON.newBSON());
                    });
                }
            }
        }
    }






    Component.onCompleted: {
        var com = Qt.createComponent("qrc:/Login/Login.qml");
        if( com.status === Component.Ready )
        {
            var e = com.createObject(root);
            e.success.connect(function(){
                e.destroy();
                repeater.model = db.find(DBKey.collection,QBSON.newBSON(),QBSON.newBSON());
            });
        }
    }


    ErrorDialog{
        id: errDialog
        z: 100

        Component.onCompleted: {
            Utility.onErrorMessageChanged.connect(function(mesaj){
                errDialog.open(mesaj);
            })
        }
    }



    function loadDevice(oid){

        var com = Qt.createComponent("qrc:/qmlsrc/Device.qml");

        if( com.status === Component.Ready )
        {
            var e = com.createObject(root,{"oid":oid});
        }


    }

}
