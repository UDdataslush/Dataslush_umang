import requests
import csv
import json
from datetime import datetime
from bs4 import BeautifulSoup
import argparse


def fetch_weather(city, url="https://www.bbc.com/weather/1255364"):
    """Fetch weather data from BBC Weather using Beautiful Soup."""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }

    response = requests.get(url, headers=headers)
    if response.status_code != 200:
        raise Exception(f"Failed to fetch data: HTTP {response.status_code}")

    soup = BeautifulSoup(response.content, 'html.parser')

    # Extract temperature
    temperature_element = soup.find('span', class_='wr-value--temperature--c')
    temperature = temperature_element.text.strip() if temperature_element else "N/A"

    # Extract weather condition
    condition_element = soup.find('div', class_='wr-day__weather-type-description')
    condition = condition_element.text.strip() if condition_element else "N/A"

    # Extract humidity (if available on the page)
    humidity_element = soup.find('div', class_='wr-u-font-weight-500')
    humidity = humidity_element.text.strip() if humidity_element else "N/A"

    # Compile the data
    weather_data = {
        'location': city,
        'temperature': temperature,
        'condition': condition,
        'humidity': humidity,
        'date': datetime.now().strftime('%Y-%m-%d')
    }

    return weather_data


def save_to_json(data, output_file):
    """Save data to a JSON file."""
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4)


def save_to_csv(data, output_file):
    """Save data to a CSV file."""
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['location', 'temperature', 'condition', 'humidity', 'date'])
        writer.writeheader()
        writer.writerow(data)


def main_cli(city, output_file, output_format):
    """Main logic for the CLI version."""
    try:
        weather_data = fetch_weather(city)

        if output_format == 'json':
            save_to_json(weather_data, output_file)
        elif output_format == 'csv':
            save_to_csv(weather_data, output_file)

        print(f"Data saved to {output_file}")
    except Exception as e:
        print(f"Error: {e}")


def main():
    # Add argparse for CLI functionality
    parser = argparse.ArgumentParser(description="Fetch and save weather data for a given city.")
    parser.add_argument("--city", type=str, help="Name of the city (e.g., London, New York)")
    parser.add_argument("--output_file", type=str, help="Name of the output file (e.g., output.json, output.csv)")
    parser.add_argument("--output_format", choices=['json', 'csv'], help="Output format (json or csv)")

    args = parser.parse_args()

    if args.city and args.output_file and args.output_format:
        # Use argparse arguments if provided
        main_cli(args.city, args.output_file, args.output_format)
    else:
        # Fallback to existing input prompt logic
        city = input("Enter the city name (e.g., London, New York): ").strip()
        if not city:
            print("Please enter a valid city name.")
            return

        output_file = input("Enter the output file name (e.g., output): ").strip()
        if not output_file:
            print("Please enter a valid output file name.")
            return

        output_format = input("Enter the output format (json or csv): ").strip().lower()
        if output_format not in ['json', 'csv']:
            print("Invalid format. Please choose 'json' or 'csv'.")
            return

        main_cli(city, output_file, output_format)


if __name__ == '__main__':
    main()
