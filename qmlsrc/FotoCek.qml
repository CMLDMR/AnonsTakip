import QtQuick 2.11
import QtMultimedia 5.8
import QtPositioning 5.11

import com.mongodb 0.7


Item {


    id: item
    anchors.fill: parent

    property string oid: ""

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#CC000000"


        PositionSource {
            id: src
            updateInterval: 1000
            active: true
            property real longtitude: -1
            property real latitude: -1

            onPositionChanged: {
                var coord = src.position.coordinate;
                textCoordinate.text = coord.longitude + " : " + coord.latitude
                longtitude = src.position.coordinate.longitude
                latitude = src.position.coordinate.latitude
            }
        }



        Column{
            anchors.fill: parent

            Rectangle {
                width: parent.width
                height: 50
                color: "DarkGray"
                Text {
                    text: qsTr("Fotoğraf Çek")
                    font.bold: true
                    font.pointSize: 10
                    font.family: "Tahoma"
                    color: "white"
                    anchors.centerIn: parent
                }


            }


            Rectangle {
                width: parent.width
                height: 250
                color: "white"
                VideoOutput {
                    source: camera
                    anchors.fill: parent
                    focus : visible // to receive focus and capture key events when visible
                }
            }

            Rectangle {
                width: parent.width
                height: 50
                color: "DarkSlateGray"
                Text {
                    text: qsTr("Çek Gönder")
                    font.bold: true
                    font.pointSize: 10
                    font.family: "Tahoma"
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if( src.latitude < 0 || src.longtitude )
                        {
                            Utility.errorMessage = "Cihazınızın Konum Bilgisini Açınız";
                        }else{
                            camera.imageCapture.capture();
                        }
                    }
                }
            }


            Rectangle {
                width: parent.width
                height: 50
                color: "DarkSlateGray"
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


    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageSaved: {

                print ("IMAGE CATURE: " + requestId + " -> "+ path +  " - " + Utility.getRandomFileName(path) );
                var fotoElement = db.uploadfile(path,Utility.getRandomFileName(path));

                var filter = QBSON.newBSON();

                filter.addOid( "_id" , oid );

                var pushObj = QBSON.newBSON();

                pushObj.addString("saat",Utility.getTime());
                pushObj.addInt64("julianDate",Utility.getDate());
                pushObj.addOid("fotooid",fotoElement.Oid);
                pushObj.addDouble("longtitude",src.longtitude);
                pushObj.addDouble("latitute",src.latitude);

                var push = QBSON.newBSON();

                push.addBson( "Fotolist" , pushObj );

                var updateobj = QBSON.newBSON();

                updateobj.addBson( "$push" , push );

                updateobj.print();

                if( db.update_one("AnonsCihazlari",filter,updateobj) )
                {
                    Utility.errorMessage = "Fotoğraf Eklendi";
                }else{
                    Utility.errorMessage = "Fotoğraf Eklenemedi!";
                }
            }

            onImageCaptured: {
//                imgSurface.source = preview;
            }
        }
    }

}
