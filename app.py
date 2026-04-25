from flask import Flask, send_file
import xml.etree.ElementTree as ET
from flask import Flask, render_template, request
from xml.dom import minidom

app = Flask(__name__)
XML_FILE = "transport.xml"

# --- Root route: filtering/search ---
@app.route("/", methods=["GET"])
def index():
    tree = ET.parse(XML_FILE)
    root = tree.getroot()
    trips = []

    code = request.args.get("code")
    departure = request.args.get("departure")
    arrival = request.args.get("arrival")
    train_type = request.args.get("train_type")
    max_price = request.args.get("max_price")

    for trip in root.findall(".//trip"):
        trip_code = trip.get("code")
        trip_type = trip.get("type")
        schedule = trip.find("schedule")
        dep = schedule.get("departure")
        arr = schedule.get("arrival")
        cls = trip.find("class")
        price = int(cls.get("price"))

        # Filtering
        if code and trip_code != code:
            continue
        if departure and departure.lower() not in dep.lower():
            continue
        if arrival and arrival.lower() not in arr.lower():
            continue
        if train_type and train_type.lower() != trip_type.lower():
            continue
        if max_price and price > int(max_price):
            continue

        trips.append({
            "code": trip_code,
            "type": trip_type,
            "departure": dep,
            "arrival": arr,
            "price": price
        })

    return render_template("index.html", trips=trips)

# --- DOM: Trip details by code ---
@app.route("/trip/<code>")
def trip_details(code):
    dom = minidom.parse(XML_FILE)
    trips = dom.getElementsByTagName("trip")
    for trip in trips:
        if trip.getAttribute("code") == code:
            schedule = trip.getElementsByTagName("schedule")[0]
            departure = schedule.getAttribute("departure")
            arrival = schedule.getAttribute("arrival")
            trip_type = trip.getAttribute("type")
            cls = trip.getElementsByTagName("class")[0]
            price = cls.getAttribute("price")
            return render_template("trip_details.html", trip={
                "code": code,
                "type": trip_type,
                "departure": departure,
                "arrival": arrival,
                "price": price
            })
    return f"Trip {code} not found", 404

# --- Statistics ---
@app.route("/stats")
def stats():
    tree = ET.parse(XML_FILE)
    root = tree.getroot()

    type_counts = {}
    cheapest = {}
    expensive = {}

    for line in root.findall(".//line"):
        line_code = line.get("code")
        min_price = float('inf')
        max_price = 0
        min_trip = ""
        max_trip = ""

        for trip in line.findall(".//trip"):
            trip_type = trip.get("type")
            type_counts[trip_type] = type_counts.get(trip_type, 0) + 1

            for cls in trip.findall("class"):
                price = int(cls.get("price"))
                if price < min_price:
                    min_price = price
                    min_trip = trip.get("code") + f" ({price})"
                if price > max_price:
                    max_price = price
                    max_trip = trip.get("code") + f" ({price})"

        cheapest[line_code] = min_trip
        expensive[line_code] = max_trip

    return render_template("stats.html",
                           type_counts=type_counts,
                           cheapest=cheapest,
                           expensive=expensive)

if __name__ == "__main__":
    app.run(debug=True)


app = Flask(__name__)


@app.route("/")
def home():
    return "<h1>Flask is working</h1>"


@app.route("/xml")
def xml():
    return send_file("transport.xml")


if __name__ == "__main__":
    app.run(debug=True)
