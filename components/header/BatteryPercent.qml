import QtQuick 2.15

Item {
    property string shade: 'light';
    property string shadeColor: {
        return shade === 'light'
            ? theme.current.clockColorLight
            : theme.current.clockColorDark;
    }

    width: batteryPercentText.width;

    Text {
        id: batteryPercentText;

//        text: Math.round(api.device.batteryPercent*100)+"%";
        text: api.device.batteryCharging
            ? Math.round(api.device.batteryPercent*100)+"%C"
            : Math.round(api.device.batteryPercent*100)+"%";
        color: shadeColor;

        anchors.verticalCenter: parent.verticalCenter;

        font {
            pixelSize: parent.height * .33;
            letterSpacing: -0.3;
            bold: true;
        }
    }
}