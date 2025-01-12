import json
from datetime import datetime
def recommend_schemes(user_details):

    print("recommend_schemes function called") 
    schemes_file_path = "lib\Backend\schemes.json"

    try:
        with open(schemes_file_path, 'r') as f:
            schemes = json.load(f)["schemes"]
    except FileNotFoundError:
        print("Error: Schemes file not found.")
        return []
    except json.JSONDecodeError:
        print("Error: Invalid JSON format in schemes file.")
        return []

    recommended_schemes = []

    # Calculate the user's age based on the provided DOB
    dob = datetime.strptime(user_details['dob'], "%d/%m/%Y")
    age = (datetime.now() - dob).days // 365  # Approximate age in years
    print(f"User Age: {age}")

    for scheme in schemes:
        criteria = scheme['eligibility_criteria']

        # Check age eligibility
        min_age = criteria.get('min_age', 0)
        max_age = criteria.get('max_age', float('inf'))
        if not (min_age <= age <= max_age):
            continue

        # Check gender eligibility
        required_gender = criteria.get('gender')
        if required_gender and user_details.get('gender') != required_gender:
            continue

        # Check state eligibility
        eligible_states = criteria.get('eligible_states', ["All"])
        if "All" not in eligible_states and user_details['state'] not in eligible_states:
            continue

        # Check if the scheme's deadline has passed
        if 'deadline' in scheme:
            deadline = datetime.strptime(scheme['deadline'], "%Y-%m-%d")
            if datetime.now() > deadline:
                continue

        # Add the scheme to recommended_schemes if all criteria are met
        recommended_schemes.append({
            "scheme_id": scheme['scheme_id'],
            "name": scheme['name'],
            "description": scheme['description'],
            "benefits": scheme['benefits'],
            "application_link": scheme['application_link'],
            "deadline": scheme['deadline']
        })

    return recommended_schemes
