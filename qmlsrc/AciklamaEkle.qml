import QtQuick 2.11
import QtQuick.Controls 2.4

import com.mongodb 0.7

Item {

    id: item
    anchors.fill: parent

    property string oid: ""


    Rectangle {
        width: parent.width
        height: parent.height
        color: "#CC000000"



        Rectangle {
            width: parent.width
            height: 350
            color: "transparent"
            anchors.centerIn: parent

            Column{
                anchors.fill: parent

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "DarkGray"
                    Text {
                        text: qsTr("Açıklama Ekle+")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }
                }


                Rectangle {
                    width: parent.width
                    height: 200
                    color: "white"
                    TextInput{
                        id: aciklamainput
                        width: parent.width
                        height: parent.height

                        Text {
                            text: qsTr("Açıklama Metni Giriniz")
                            font.bold: true
                            font.pointSize: 10
                            font.family: "Tahoma"
                            color: "gray"
                            anchors.centerIn: parent
                            visible: !parent.text
                        }


                    }
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "DarkSlateGray"
                    Text {
                        text: qsTr("Kaydet")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {

                            var filter = QBSON.newBSON();

                            filter.addOid("_id",oid);

                            var push = QBSON.newBSON();


                            var aciklamaObj = QBSON.newBSON();

                            aciklamaObj.addString("aciklama",aciklamainput.text);
                            aciklamaObj.addString("saat",Utility.getTime());
                            aciklamaObj.addInt64("julianDate",Utility.getDate());

                            var pushField = QBSON.newBSON();

                            pushField.addBson("aciklamalar",aciklamaObj);

                            push.addBson("$push",pushField);

                            if( db.update_one("AnonsCihazlari",filter,push) )
                            {
                                item.destroy();
                            }else{
                                Utility.errorMessage = "Açıklama Eklenemedi";
                            }

                        }
                    }
                }


                Rectangle {
                    width: parent.width
                    height: 50
                    color: "DarkGray"
                    Text {
                        text: qsTr("Kapat")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
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


}
