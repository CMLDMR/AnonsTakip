import QtQuick 2.11
import com.mongodb 0.7
import QtQuick.Controls 2.4
import QtPositioning 5.11

Item {

    id: item

    anchors.fill: parent

    signal added();

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#CC000000"


        Rectangle {
            width: parent.width
            height: 300
            color: "white"
            anchors.centerIn: parent

            Column{
                anchors.fill: parent

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "Gray"
                    Text {
                        text: qsTr("Yeni Cihaz Ekle")
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "black"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "white"

                    TextInput{
                        id: deviceName
                        width: parent.width
                        height: parent.height
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "black"
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        Text {
                            text: qsTr("Cihaz Adını Giriniz")
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
                    color: "white"
                    ComboBox{
                        id: mahalleComboBox
                        anchors.fill: parent
                        property var list: new Array
                        Component.onCompleted: {

                            list = [];

                            var _list = db.find("Mahalleler",QBSON.newBSON(),QBSON.newBSON());

                            print ("length " + _list.length);
                            for( var i = 0 ; i < _list.length ; i++ )
                            {
                                var e = _list[i];
                                list[i] = e.getElement("Mahalle").String
                            }

                            model = list;
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "Gray"

                    PositionSource {
                        id: src
                        updateInterval: 1000
                        active: true
                        property real longtitude: src.position.coordinate.longitude
                        property real latitude: src.position.coordinate.latitude

                        onPositionChanged: {
                            var coord = src.position.coordinate;
                            textCoordinate.text = coord.longitude + " : " + coord.latitude
                            longtitude = src.position.coordinate.longitude
                            latitude = src.position.coordinate.latitude
                        }
                    }

                    Text {
                        id: textCoordinate
                        font.bold: true
                        font.pointSize: 10
                        font.family: "Tahoma"
                        color: "white"
                        anchors.centerIn: parent
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
                            addNew();
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: "Gray"
                    Text {
                        text: qsTr("İptal")
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


    function addNew(){


        if( !src.longtitude || !src.latitude )
        {
            Utility.errorMessage = "Konum Alınamadı. Lütfen Cihaz Konumunu Açın";
            return;
        }

        print ("LONG: " + src.longtitude + " - " + "LAT: " + src.latitude );

        if( deviceName.text.length === 0 )
        {
            Utility.errorMessage = "Cihaz Adını Boş Geçemezsiniz";
            return;
        }

        if( mahalleComboBox.currentText === "NULL" )
        {
            Utility.errorMessage = "Mahalle Seçmediniz";
            return;
        }



        var obj = QBSON.newBSON();



        QBSON.insertString(obj,"cihazadi",deviceName.text);
        QBSON.insertString(obj,"mahalle",mahalleComboBox.currentText);

        QBSON.insertDouble( obj , "longtitude" , src.longtitude );
        QBSON.insertDouble( obj , "latitute" , src.latitude );



        if( db.insert_one(DBKey.collection,obj) )
        {
            added();
        }else{
            Utility.errorMessage = "Cihaz Kayıt Edilemedi";
        }




    }
}
