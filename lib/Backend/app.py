from flask import Flask, request, jsonify
import json
from scheme_recommendation import * 
app = Flask(__name__)

@app.route('/get_user_data', methods=['GET'])
def get_user_data():
    # Get the user_data query parameter from the request
    user_data_str = request.args.get('user_data')
    print("got it")
    if user_data_str:
        try:
            user_data = json.loads(user_data_str)

            recommendations = recommend_schemes(user_data)
            print(recommendations)
            user_data['recommended_schemes'] = recommendations
            return jsonify(user_data)
        except json.JSONDecodeError:
            return jsonify({"error": "Invalid user data format"}), 400
    else:
        return jsonify({"error": "User data not found"}), 404


if __name__ == '__main__':
     app.run(host='0.0.0.0', port=5000, debug=True)
