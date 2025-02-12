import requests
import csv
import json
import typer
from datetime import datetime, timedelta
from bs4 import BeautifulSoup

# Dictionary mapping Indian cities to their BBC Weather location codes
INDIAN_CITIES = {
    "Delhi": "1273294",
    "Mumbai": "1275339",
    "Chennai": "1264527",
    "Kolkata": "1275004",
    "Bangalore": "1277333"
}

app = typer.Typer()

def fetch_weather(city, url, date_filter=None):
    """Fetch weather data from BBC Weather using Beautiful Soup."""
    headers = {
        'User-Agent': ('Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
                       'AppleWebKit/537.36 (KHTML, like Gecko) '
                       'Chrome/91.0.4472.124 Safari/537.36')
    }

    response = requests.get(url, headers=headers)
    if response.status_code != 200:
        raise Exception(f"Failed to fetch data: HTTP {response.status_code}")

    soup = BeautifulSoup(response.content, 'html.parser')

    temperature_element = soup.find('span', class_='wr-value--temperature--c')
    temperature = temperature_element.text.strip() if temperature_element else "N/A"

    condition_element = soup.find('div', class_='wr-day__weather-type-description')
    condition = condition_element.text.strip() if condition_element else "N/A"

    humidity_element = soup.find('div', class_='wr-u-font-weight-500')
    humidity = humidity_element.text.strip() if humidity_element else "N/A"

    weather_data = {
        'location': city,
        'temperature': temperature,
        'condition': condition,
        'humidity': humidity,
        'date': datetime.now().strftime('%Y-%m-%d')
    }

    if date_filter and weather_data['date'] != date_filter:
        return None

    return weather_data

def fetch_weather_for_multiple_cities(cities, date_filter=None):
    """Fetch weather data for multiple cities."""
    all_weather_data = []
    for city, city_code in cities.items():
        url = f"https://www.bbc.com/weather/{city_code}"
        weather_data = fetch_weather(city, url, date_filter)
        if weather_data:
            all_weather_data.append(weather_data)
    return all_weather_data

def save_to_json(data, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4)

def save_to_csv(data, output_file):
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['location', 'temperature', 'condition', 'humidity', 'date'])
        writer.writeheader()
        for row in data:
            writer.writerow(row)

def main_cli():
    """Interactive CLI for fetching and saving weather data for multiple cities."""
    print("Available Indian cities:")
    for idx, city in enumerate(INDIAN_CITIES.keys(), start=1):
        print(f"{idx}. {city}")
    
    city_choice = input("Select cities by entering the corresponding numbers separated by commas (e.g. 1, 3, 4): ").strip()
    try:
        city_indexes = [int(idx.strip()) - 1 for idx in city_choice.split(",")]
        if any(idx < 0 or idx >= len(INDIAN_CITIES) for idx in city_indexes):
            print("Invalid selection.")
            return
    except ValueError:
        print("Invalid input. Please enter numbers separated by commas.")
        return
    
    selected_cities = {city: INDIAN_CITIES[city] for idx, city in enumerate(INDIAN_CITIES.keys()) if idx in city_indexes}
    
    date_filter = input("Enter the date (YYYY-MM-DD) to filter the weather data (press enter to skip): ").strip()
    if date_filter:
        try:
            datetime.strptime(date_filter, '%Y-%m-%d')
        except ValueError:
            print("Invalid date format. Please enter in YYYY-MM-DD format.")
            return
    else:
        date_filter = None
    
    output_file = input("Enter the output file name (without extension): ").strip()
    if not output_file:
        print("File name cannot be empty!")
        return
    
    output_format = input("Enter the output format (json or csv): ").strip().lower()
    if output_format not in ['json', 'csv']:
        print("Invalid format. Please choose 'json' or 'csv'.")
        return
    
    output_file += f".{output_format}"
    
    try:
        weather_data = fetch_weather_for_multiple_cities(selected_cities, date_filter)
        if not weather_data:
            print(f"No weather data available for the selected cities on {date_filter}")
            return
        
        if output_format == 'json':
            save_to_json(weather_data, output_file)
        else:
            save_to_csv(weather_data, output_file)
        
        print(f"Weather data for the selected cities saved to {output_file}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main_cli()
