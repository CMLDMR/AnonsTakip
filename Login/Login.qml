import QtQuick 2.11
import QtQuick.Controls 2.4

import com.mongodb 0.7

Item {

    id: item
    anchors.fill: parent


    Rectangle {
        width: parent.width > 900 ? 900 : parent.width
        height: parent.height
        color: "#CC000000"
        MouseArea{
            anchors.fill: parent
        }


        Rectangle {
            width: parent.width
            height: 150
            color: "Gray"
            anchors.centerIn: parent

            Column{
                anchors.fill: parent

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "white"
                    TextInput{
                        id: telinput
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        width: parent.width
                        height: parent.height
                        Text {
                            text: qsTr("Telefon Numarası Giriniz")
                            font.bold: true
                            font.pointSize: 10
                            font.family: "Tahoma"
                            color: "Gray"
                            anchors.centerIn: parent
                            visible: !parent.text
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "white"
                    TextInput{
                        id: sifreinput
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        width: parent.width
                        height: parent.height
                        echoMode: TextInput.Password
                        Text {
                            text: qsTr("Şifre Giriniz")
                            font.bold: true
                            font.pointSize: 10
                            font.family: "Tahoma"
                            color: "Gray"
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
                        text: qsTr("Giriş")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            login();
                        }
                    }

                }


            }

        }

    }


    function login(){

        var filter = QBSON.newBSON();

        filter.addString("telefon",telinput.text);
        filter.addString("password",sifreinput.text);

        var count  = db.count("Personel",filter);

        if( count )
        {
            item.destroy();
        }else{
            Utility.errorMessage = "Hatalı Bilgi Girişi Yaptınız. Tekrar Deneyiniz"
        }



    }


}
