import QtQuick 2.15
import QtGraphicalEffects 1.12

Rectangle {
    property int systemIndex: 0;
    property int collectionCount: {
        return api.collections.count;
    };
    property var currentSystem: {
        return api.collections.get(systemIndex);
    };
    property string shortName: {
        return currentSystem.shortName;
    };
    property string systemColor: {
        return systemData.systemColors[shortName] ?? systemData.systemColors['default'];
    }
    property string systemCompany: {
        return systemData.systemCompanies[shortName] ?? '';
    }

    function updateIndex(to) {
        systemIndex = to;
        /* backgroundColor.color = systemColor; */
    }

    function letterSpacing(str) {
        return str === 'NES' ? 1.0 : -1.0
    }

    Component.onCompleted: {
        systemIndex = api.memory.get('systemIndex') ?? 0;
    }

    Component.onDestruction: {
        api.memory.set('systemIndex', systemIndex);
    }

    SystemData { id: systemData }

    // background color, fades when system changes
    Rectangle {
        id: backgroundColor;

        width: parent.width;
        height: parent.height;
        color: systemColor;

        Behavior on color {
            ColorAnimation {
                duration: 355;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    // dots
    PageIndicator {
        currentIndex: systemIndex;
        pageCount: collectionCount;

        anchors {
            horizontalCenter: parent.horizontalCenter;
            bottom: parent.bottom;
            bottomMargin: 25;
        }
    }

    // background stripe
    Image {
        source: '../../assets/images/menu-side-2.png';

        anchors {
            top: parent.top;
            right: parent.right;
            rightMargin: 70;
        }
    }

    Text {
        id: title;

        text: currentSystem.name;
        color: '#ffffff';
        width: 280;
        wrapMode: Text.WordWrap;
        lineHeight: 0.8;

        font {
            pixelSize: 36;
            letterSpacing: letterSpacing(modelData.name)
            bold: true;
        }

        anchors {
            verticalCenter: parent.verticalCenter;
            left: parent.left;
            leftMargin: 30;
            verticalCenterOffset: -5;
        }

        DropShadow {
            anchors.fill: parent;
            source: parent;
            verticalOffset: 10;
            color: '#20000000';
            radius: 20;
            samples: 10;
        }
    }

    Text {
        text: currentSystem.games.count + ' games';
        color: '#ffffff';
        opacity: 0.7;

        anchors {
            left: parent.left;
            leftMargin: 30;
            top: title.bottom;
            topMargin: 15;
        }

        font {
            pixelSize: 14
            letterSpacing: -0.3
            bold: true
        }
    }

    Text {
        text: systemCompany.toUpperCase();
        color: '#ffffff';
        opacity: 0.7;

        font {
            pixelSize: 12;
            letterSpacing: 1.3;
            bold: true;
        }

        anchors {
            left: parent.left;
            leftMargin: 30;
            bottom: title.top;
            bottomMargin: 5;
        }
    }

    Image {
        id: device;

        source: '../../assets/images/devices/' + shortName + '.png';
        cache: true;
        asynchronous: true;

        anchors {
            verticalCenter: parent.verticalCenter;
            verticalCenterOffset: 10;
            right: parent.right;
            rightMargin: 0;
        }

        /* states: [ */
        /*     State{ */
        /*         name: 'inactiveRight'; when: !(home_item_container.ListView.isCurrentItem) && currentIndex < index */
        /*         PropertyChanges { target: device; anchors.rightMargin: -160.0 } */
        /*     }, */
        /*     State{ */
        /*         name: 'inactiveLeft'; when: !(home_item_container.ListView.isCurrentItem) && currentIndex > index */
        /*         PropertyChanges { target: device; anchors.rightMargin: 40.0 } */
        /*     }, */
        /* ] */

        /* transitions: Transition { */
        /*     NumberAnimation { properties: 'anchors.rightMargin'; easing.type: Easing.InOutCubic; duration: 225  } */
        /* } */
    }

    // temporary
    Rectangle {
        width: 20;
        height: 20;
        color: 'black';
        x: 100;
        y: 100;

        Text {
            anchors.centerIn: parent;
            text: shortName;
            color: 'white';
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                updateIndex((systemIndex + 1) % 6);
            }
        }
    }
}

// ListView {
//     property var footerTitle: {
//         return (currentIndex + 1) + " of " + allSystems.count
//     }
//
//     property var headerFocused: false
//
//     property var bgIndex: 0
//     property var itemTextColor: {
//         systemsListView.activeFocus ? "#ffffff"  : "#60ffffff"
//     }
//     width: parent.width
//     id: systemsListView
//     anchors.verticalCenter: parent.verticalCenter
//     anchors.left: parent.left
//     anchors.right: parent.right
//     anchors.bottom: parent.bottom
//     model: allSystems
//     cacheBuffer: 10
//     delegate: systemsDelegate
//     orientation: ListView.Horizontal
//     highlightRangeMode: ListView.StrictlyEnforceRange
//     preferredHighlightBegin: 0
//     preferredHighlightEnd: 320 + 220
//     snapMode: ListView.SnapToItem
//     highlightMoveDuration: 325
//     highlightMoveVelocity: -1
//     keyNavigationWraps: false
//     spacing: 50
//     currentIndex: currentCollectionIndex
//     move: Transition {
//         NumberAnimation { properties: "x,y"; duration: 3000 }
//     }
//     displaced: Transition {
//         NumberAnimation { properties: "x,y"; duration: 3000 }
//     }
//     Keys.onLeftPressed: {
//         decrementCurrentIndex(); navSound.play(); systemsBackground.bgIndex = currentIndex
//     }
//
//     Keys.onRightPressed: {
//         incrementCurrentIndex(); navSound.play();  systemsBackground.bgIndex = currentIndex
//     }
//
//     Timer {
//         id: timer
//     }
//
//     function delay(delayTime, cb) {
//         timer.interval = delayTime;
//         timer.repeat = false;
//         timer.triggered.connect(cb);
//         timer.start();
//     }
//
//
//     PageIndicator {
//         currentIndex: systemsListView.currentIndex
//         pageCount: allSystems.count
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.bottom: parent.bottom
//         anchors.bottomMargin: 25
//         opacity: headerFocused ? 0.5 : 1.0
//     }
//
//     Rectangle {
//         property int bgIndex: -1
//         id: systemsBackground
//         width: layoutScreen.width
//         height: layoutScreen.height
//         anchors.top: parent.top
//         anchors.left: parent.left
//         anchors.topMargin: -55
//         z: -1
//         Behavior on bgIndex {
//             ColorAnimation {
//                 target: systemsBackground; property: "color"; to: systemColors[allSystems.get(currentIndex).shortName] ?? systemColors["default"]; duration: 335
//             }
//         }
//         transitions: Transition {
//             ColorAnimation { properties: "color"; easing.type: Easing.InOutQuad ; duration: 335 }
//         }
//     }
//
//     Component.onDestruction: {
//         setCollectionIndex(systemsListView.currentIndex)
//     }
//
//     Component.onCompleted: {
//         positionViewAtIndex(currentCollectionIndex, ListView.Center)
//         delay(50, function() {
//             systemsListView.positionViewAtIndex(currentCollectionIndex, ListView.Center)
//         })
//         systemsBackground.bgIndex = currentIndex
//     }
//     Component {
//         id: systemsDelegate
//
//
//         Item {
//             id: home_item_container
//             width: layoutScreen.width
//             height: layoutScreen.height - 55 - 55 - 35
//             scale: 1.0
//
//             z: 100 - index
//             Keys.onPressed: {
//                 if (api.keys.isAccept(event)) {
//                     event.accepted = true;
//
//                     //We update the collection we want to browse
//                     setCollectionListIndex(0)
//                     setCollectionIndex(home_item_container.ListView.view.currentIndex)
//
//                     //We change Pages
//                     navigate('GamesPage');
//
//                     return;
//                 }
//                 if (api.keys.isFilters(event)) {
//                     event.accepted = true;
//                     toggleZoom();
//                     return;
//                 }
//             }
//
//
//             Rectangle {
//                 id: systemsListView_item
//                 width: parent.width
//                 height: parent.height
//                 color:  "transparent" //systemColors[modelData.shortName]
//
//                 states: [
//
//                     State{
//                         name: "inactive"; when: !(home_item_container.ListView.isCurrentItem && !headerFocused)
//                         PropertyChanges { target: home_item_container; scale: 1.0; opacity: 1.0}
//                     },
//
//                     State {
//                         name: "active"; when: home_item_container.ListView.isCurrentItem && !headerFocused
//                         PropertyChanges { target: home_item_container; scale: 1.0; opacity: 1.0}
//                     }
//                 ]
//
//                 transitions: Transition {
//                     NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutCubic; duration: 225  }
//                 }
//
//                 Image {
//                     id: menu_mask
//                     //width: 136
//                     width: layoutScreen.height * 0.283333
//                     height: layoutScreen.height
//                     anchors.top: parent.top
//                     anchors.right: parent.right
//                     anchors.leftMargin: 0
//                     anchors.topMargin: -55
//                     anchors.rightMargin: 70
//                     z: 0
//                     source: "../assets/images/menu-side-2.png"
//                 }
//
//                 Image {
//                     id: device
//                     source: "../assets/images/devices/"+modelData.shortName+".png"
//                     anchors.right: parent.right
//                     anchors.verticalCenter: parent.verticalCenter
//                     anchors.rightMargin: 0
//                     anchors.verticalCenterOffset: 10
//                     cache: true
//                     asynchronous: true
//                     scale: 1.0
//                     states: [
//
//                         State{
//                             name: "inactiveRight"; when: !(home_item_container.ListView.isCurrentItem) && currentIndex < index
//                             PropertyChanges { target: device; anchors.rightMargin: -160.0; opacity: 1.0}
//                         },
//
//                         State{
//                             name: "inactiveLeft"; when: !(home_item_container.ListView.isCurrentItem) && currentIndex > index
//                             PropertyChanges { target: device; anchors.rightMargin: 40.0; opacity: 1.0}
//                         },
//
//                         State {
//                             name: "active"; when: home_item_container.ListView.isCurrentItem && !headerFocused
//                             PropertyChanges { target: device; anchors.rightMargin: -60.0; opacity: 1.0; scale: 1.0}
//                         },
//
//                         State {
//                             name: "inactive"; when: home_item_container.ListView.isCurrentItem  && headerFocused
//                             PropertyChanges { target: device; anchors.rightMargin: -60.0; opacity: 1.0; scale: 0.9}
//                         }
//                     ]
//
//                     transitions: Transition {
//                         NumberAnimation { properties: "scale, opacity, anchors.rightMargin"; easing.type: Easing.InOutCubic; duration: 225  }
//                     }
//
//                 }
//
//                 Text {
//                     id: title
//                     text: modelData.name
//                     font.pixelSize: 36
//                     font.letterSpacing: letterSpacing(modelData.name)
//                     font.bold: true
//                     color: itemTextColor
//                     width: 280
//                     wrapMode: Text.WordWrap
//                     anchors.rightMargin: 30
//                     visible: true
//                     lineHeight: 0.8
//                     anchors.verticalCenter: parent.verticalCenter
//                     anchors.left: parent.left
//                     anchors.leftMargin: 30
//                     anchors.verticalCenterOffset: -5
//                 }
//
//                 DropShadow {
//                     anchors.fill: title
//                     source: title
//                     verticalOffset: 10
//                     color: "#20000000"
//                     radius: 20
//                     samples: 10
//                 }
//
//                 Text {
//                     text: modelData.games.count + " games"
//                     font.pixelSize: 14
//                     font.letterSpacing: -0.3
//                     font.bold: true
//                     color: itemTextColor
//                     opacity: 0.7
//                     anchors.bottomMargin: -27
//                     anchors.left: parent.left
//                     anchors.leftMargin: 30
//                     anchors.bottom: title.bottom
//                     visible: true
//                 }
//
//                 Text {
//                     text: systemCompanies[modelData.shortName].toUpperCase()
//                     font.pixelSize: 12
//                     font.letterSpacing: 1.3
//                     font.bold: true
//                     color: itemTextColor
//                     opacity: 0.7
//                     anchors.bottomMargin: -1
//                     anchors.left: parent.left
//                     anchors.leftMargin: 30
//                     anchors.bottom: title.top
//                 }
//             }
//         }
//     }
// }
