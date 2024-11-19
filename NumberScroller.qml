pragma ComponentBehavior: Bound
import QtQuick

Row{
    id: row
    property int digits: 5
    property double fontSize: 32

    Repeater{
        id: rep
        model: row.digits
        ScrollerDigit {
        fontSize: row.fontSize
        }
    }

    function setValue(value) {
        const charset = String(value);
        const charlen = digits - charset.length;

        if (charlen < 0)
            return

        for (var i=0; i<charlen; i++)
            rep.itemAt(i).value = 0

        for (var i=0; i<charset.length; i++)
            rep.itemAt(i+charlen).value = parseInt(charset[i])
    }
}
