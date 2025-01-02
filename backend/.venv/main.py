import json
import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# Path to the JSON file where user data is stored
USER_DATA_FILE = os.path.join(os.path.dirname(__file__), 'users.json')

# Helper function to load user data from the JSON file
def load_users():
    try:
        with open(USER_DATA_FILE, 'r') as file:
            users = json.load(file)
    except FileNotFoundError:
        users = {}
    return users

# Helper function to save user data to the JSON file
def save_users(users):
    with open(USER_DATA_FILE, 'w') as file:
        json.dump(users, file, indent=4)

# Route for registration
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({"message": "Username and password are required"}), 400

    users = load_users()
    if username in users:
        return jsonify({"message": "Username already exists"}), 400

    users[username] = password
    save_users(users)
    return jsonify({"message": "Registration successful"}), 201

# Route for login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({"message": "Username and password are required"}), 400

    users = load_users()
    if username not in users:
        return jsonify({"message": "User not found"}), 404

    if users[username] != password:
        return jsonify({"message": "Invalid credentials"}), 401

    return jsonify({"message": "Login successful"}), 200

# Replace these with environment variables for security
ONESIGNAL_APP_ID = os.getenv("ONESIGNAL_APP_ID", "c409080d-f66a-43e9-bc4e-35433c58e939")
ONESIGNAL_API_KEY = os.getenv("ONESIGNAL_API_KEY", "os_v2_app_yqeqqdpwnjb6tpcogvbtywhjhhzslq7hehwu3ankfkiiqe6kisqczna3xsslb2xcvhqqupcvaxx6yne4vl7tk7pgkj56quramuwqoaa")


@app.route('/send_notification', methods=['POST'])
def send_notification():
    data = request.get_json()

    # Extract and validate input fields
    app_id = data.get('app_id')
    player_ids = data.get('include_player_ids')
    title = data.get('headings', {}).get('en')
    message = data.get('contents', {}).get('en')

    if not app_id or not player_ids or not title or not message:
        return jsonify({"error": "app_id, include_player_ids, headings, and contents are required"}), 400

    # OneSignal API URL
    url = "https://onesignal.com/api/v1/notifications"

    # Construct payload for OneSignal API
    payload = {
        "app_id": app_id,
        "include_player_ids": player_ids,
        "headings": {"en": title},
        "contents": {"en": message}
    }

    # Construct headers for OneSignal API
    headers = {
        "Authorization": f"Basic {ONESIGNAL_API_KEY}",
        "Content-Type": "application/json",
    }

    try:
        # Send the request to OneSignal
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()  # Raise exception for HTTP errors
        response_data = response.json()

        # Check if OneSignal responded with an error
        if "errors" in response_data:
            return jsonify({"error": "OneSignal API error", "details": response_data.get("errors")}), 500

        return jsonify({"message": "Notification sent successfully", "response": response_data}), 200

    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Failed to send notification: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
