import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
     objectName: "mainPage"

     SilicaListView {
        anchors.fill: parent

        header: Column {
            width: parent.width
            height: header.height + mainColumn.height + Theme.paddingLarge

            PageHeader {
                id: header
                title: "ИМТ"
                extraContent.children: [
                    IconButton {
                        objectName: "aboutButton"
                        icon.source: "image://theme/icon-m-about"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                    }
                ]
            }

            Column {
                id: mainColumn
                width: parent.width
                spacing: Theme.paddingLarge

                TextField {
                    id: weight
                    focus: true
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    label: qsTrId("введите вес в кг")
                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    EnterKey.onClicked: height.focus = true
                }

                TextField {
                    id: height
                    focus: true
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    label: qsTrId("введите рост в см")
                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    EnterKey.onClicked: circle.focus = true
                }

                TextField {
                    id: circle
                    focus: true
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    label: qsTrId("окружность запястья в см")
                }

                ComboBox {
                    id: combo
                    label: qsTrId("Выберите пол:")
                    currentIndex: 0
                    menu: ContextMenu {

                        MenuItem {
                            //% "automatic"
                            text: qsTrId("мужской")
                        }

                        MenuItem {
                            //% "manual"
                            text: qsTrId("женский")
                        }
                    }
                }


                Button {
                    id: calculateButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ВЫЧИСЛИТЬ"
                    onClicked: onCalculateClicked()
                }

                Label {
                    id: result1
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: result2
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: result3
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            function onCalculateClicked(){
                  var h=Number(height.text);
                  var w=Number(weight.text);
                  var c=Number(circle.text);
                  if (isNullInField(height.text)||isNullInField(weight.text)||isNullInField(circle.text)){
                      result1.text = "Заполните все поля!";
                      result2.text = "";
                      result3.text = "";
                      return;
                  }
                  var gen,index,s;
                  if (combo.currentIndex===0){
                      gen=19;
                  }else{
                      gen=16;
                  }
                   h=h/100;
                   index=w/(h*h);
                   index=index*(gen/c);
                   if(index<16)s="дефицит веса";
                   else if(index>=16&&index<20)s="Недостаточный вес";
                   else if(index>=20&&index<25)s="Норма";
                   else if(index>=25&&index<30)s="Предожирение";
                   else if(index>=30&&index<35)s="Первая степень ожирения";
                   else if(index>=35&&index<40)s="Вторая степень ожирения";
                   else s="Морбидное ожирение";

                  result1.text = somatoType(gen,c) + "\nИМТ="+index.toFixed(2);
                  result2.text = s
                  if(s==="Норма"){
                      result2.color = "green"
                  }else{
                      result2.color = "red"
                  }
                  result3.text = normalMassMin(c,h,gen) + "\n" + normalMassMax(c,h,gen);
            }
            function isNullInField(p){
                    return p.length === 0;
                }
            function  normalMassMin(x,y,z){
                  var im=x*(y*y)/z;
                  return "Нижний предел нормального веса:\n"+20*im.toFixed(2)+" кг";
              }
            function normalMassMax(x,y,z){
                var im=x*(y*y)/z;
                return "Верхний предел нормального веса:\n"+25*im.toFixed(2)+" кг";
            }
            function  somatoType(a,b){
                var s="";
                var asthenic = "Тип телосложения: астенический.";
                var normosthenic = "Тип телосложения: нормостенический";
                var hypersthenic = "Тип телосложения: гиперстенический";
                switch(a){
                    case 19:
                        if(b<18)s=asthenic;
                        else if(b>=18&&b<=20)s=normosthenic;
                        else s=hypersthenic;
                        break;
                    case 16:
                        if(b<15)s=asthenic;
                        else if(b>=15&&b<=17)s=normosthenic;
                        else s=hypersthenic;
                        break;
                        default:
                        break;
                }
                return s;
            }
        }

        VerticalScrollDecorator {}

        }
     }
