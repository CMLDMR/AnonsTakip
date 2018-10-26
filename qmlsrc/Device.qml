import QtQuick 2.11
import QtQuick.Controls 2.4

import com.mongodb 0.7


Item {

    id: item
    anchors.fill: parent

    property string oid: ""

    property QBSON deviceObj


    Rectangle {
        width: parent.width
        height: parent.height
        color: "#CC000000"
        MouseArea{
            anchors.fill: parent
        }


        Rectangle {
            width: parent.width
            height: 200
            color: "white"
            anchors.centerIn: parent


            Column{
                anchors.fill: parent
                spacing: 2

                Rectangle {
                    width: item.width
                    height: 50
                    color: "DarkSlateGray"
                    Text {
                        id: devicename
                        text: deviceObj.getElement("cihazadi").String
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    width: item.width
                    height: 50
                    color: "DarkSlateBlue"
                    Text {
                        id: text1
                        text: qsTr("Fotoğraf Ekle")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    width: item.width
                    height: 50
                    color: "FireBrick"
                    Text {
                        text: qsTr("Açıklama Ekle+")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {



                            var com = Qt.createComponent("qrc:/qmlsrc/AciklamaEkle.qml");

                            if( com.status === Component.Ready )
                            {
                                var e = com.createObject(item,{"oid":oid});
                            }else{
                                print ("Component Not Ready");
                            }
                        }
                    }
                }

                Rectangle {
                    width: item.width
                    height: 50
                    color: "Gray"
                    Text {
                        text: qsTr("Kapat")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "black"
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            item.destroy();
                        }
                    }
                }

            }
        }


    }


    Component.onCompleted: {

        var filter = QBSON.newBSON();

        filter.addOid("_id",oid);


        deviceObj = db.find_one("AnonsCihazlari",filter,QBSON.newBSON());

        deviceObj.print();

    }


}
