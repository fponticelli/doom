# TODO:

## components
```
class Component {
  function componentDidMount() : Void;
  function componentWillMount() : Void;
  function componentWillUnmount() : Void;
}
```

## better event handlers
make EventHandler abstract to support other signatures:
  * Map<String, String> -> Void (auto-prevent default and autocapture values from all inputs under element)

## keyed/ided compontents/nodes

## [mixins](https://facebook.github.io/react/docs/reusable-components.html#mixins)


## Build SVG sample
function pieChart(percentage, size, color) {
    var svgns = "http://www.w3.org/2000/svg";
    var chart = document.createElementNS(svgns, "svg:svg");
    chart.setAttribute("width", size);
    chart.setAttribute("height", size);
    chart.setAttribute("viewBox", "0 0 " + size + " " + size);
    // Background circle
    var back = document.createElementNS(svgns, "circle");
    back.setAttributeNS(null, "cx", size / 2);
    back.setAttributeNS(null, "cy", size / 2);
    back.setAttributeNS(null, "r",  size / 2);
    var color = "#d0d0d0";
    if (size > 50) {
        color = "#ebebeb";
    }
    back.setAttributeNS(null, "fill", color);
    chart.appendChild(back);
    // primary wedge
    var path = document.createElementNS(svgns, "path");
    var unit = (Math.PI *2) / 100;    
    var startangle = 0;
    var endangle = percentage * unit - 0.001;
    var x1 = (size / 2) + (size / 2) * Math.sin(startangle);
    var y1 = (size / 2) - (size / 2) * Math.cos(startangle);
    var x2 = (size / 2) + (size / 2) * Math.sin(endangle);
    var y2 = (size / 2) - (size / 2) * Math.cos(endangle);
    var big = 0;
    if (endangle - startangle > Math.PI) {
        big = 1;
    }
    var d = "M " + (size / 2) + "," + (size / 2) +  // Start at circle center
        " L " + x1 + "," + y1 +     // Draw line to (x1,y1)
        " A " + (size / 2) + "," + (size / 2) +       // Draw an arc of radius r
        " 0 " + big + " 1 " +       // Arc details...
        x2 + "," + y2 +             // Arc goes to to (x2,y2)
        " Z";                       // Close path back to (cx,cy)
    path.setAttribute("d", d); // Set this path
    path.setAttribute("fill", '#f05f3b');
    chart.appendChild(path); // Add wedge to chart
    // foreground circle
    var front = document.createElementNS(svgns, "circle");
    front.setAttributeNS(null, "cx", (size / 2));
    front.setAttributeNS(null, "cy", (size / 2));
    front.setAttributeNS(null, "r",  (size * 0.17)); //about 34% as big as back circle
    front.setAttributeNS(null, "fill", "#fff");
    chart.appendChild(front);
    return chart;
}
var c = document.getElementById('container');
c.appendChild( pieChart(10, 70 ) );
c.appendChild( pieChart(66, 70 ) );
c.appendChild( pieChart(99, 70 ) );
c.appendChild( pieChart(100, 70) );
c.appendChild( pieChart(33, 30 ) );
c.appendChild( pieChart(66, 30 ) );
c.appendChild( pieChart(99, 30 ) );
