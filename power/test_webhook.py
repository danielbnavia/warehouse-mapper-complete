#!/usr/bin/env python3
"""
Test Webhook Script for Power Automate Flow
Sends sample payload to test the Scope Mapper flow
"""

import json
import requests
import sys
from datetime import datetime
from typing import Dict, Any

def load_sample_payload(filepath: str = "sample_webhook_payload.json") -> Dict[str, Any]:
    """Load sample payload from JSON file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: {filepath} not found")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        sys.exit(1)

def send_webhook(webhook_url: str, payload: Dict[str, Any]) -> None:
    """Send payload to webhook URL and display response"""

    print("=" * 60)
    print("Power Automate Webhook Tester")
    print("=" * 60)
    print(f"\nWebhook URL: {webhook_url}")
    print(f"Timestamp: {datetime.now().isoformat()}")
    print("\nPayload Summary:")
    print(f"  Project: {payload.get('scopeDocument', {}).get('title', 'N/A')}")
    print(f"  Action Items: {len(payload.get('actionItems', []))}")
    print(f"  Missing Information: {len(payload.get('analysis', {}).get('missingInformation', []))}")
    print("\nSending request...")
    print("-" * 60)

    try:
        headers = {
            'Content-Type': 'application/json',
            'User-Agent': 'Scope-Mapper-Webhook-Tester/1.0'
        }

        response = requests.post(
            webhook_url,
            json=payload,
            headers=headers,
            timeout=30
        )

        # Display response
        print(f"\nResponse Status: {response.status_code} {response.reason}")
        print("-" * 60)

        if response.status_code == 200:
            print("✓ SUCCESS - Tasks created successfully!")

            try:
                response_data = response.json()
                print("\nResponse Details:")
                print(json.dumps(response_data, indent=2))

                if 'tasksCreated' in response_data:
                    tasks = response_data['tasksCreated']
                    print(f"\nTasks Created:")
                    print(f"  Action Items: {tasks.get('actionItems', 0)}")
                    print(f"  Missing Information: {tasks.get('missingInformation', 0)}")

            except json.JSONDecodeError:
                print("\nResponse Body:")
                print(response.text)

        elif response.status_code == 400:
            print("✗ BAD REQUEST - Invalid payload format")
            print("\nResponse:")
            print(response.text)

        elif response.status_code == 500:
            print("✗ SERVER ERROR - Flow execution failed")
            try:
                error_data = response.json()
                print("\nError Details:")
                print(json.dumps(error_data, indent=2))
            except json.JSONDecodeError:
                print("\nResponse:")
                print(response.text)

        else:
            print(f"✗ UNEXPECTED STATUS CODE: {response.status_code}")
            print("\nResponse:")
            print(response.text)

        print("\n" + "=" * 60)

    except requests.exceptions.Timeout:
        print("✗ ERROR: Request timed out after 30 seconds")
        sys.exit(1)

    except requests.exceptions.ConnectionError:
        print("✗ ERROR: Could not connect to webhook URL")
        print("Check that the URL is correct and accessible")
        sys.exit(1)

    except requests.exceptions.RequestException as e:
        print(f"✗ ERROR: {str(e)}")
        sys.exit(1)

def create_custom_payload() -> Dict[str, Any]:
    """Create a minimal custom payload for testing"""
    return {
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "scopeDocument": {
            "title": "Test Integration Project",
            "rawText": "This is a test integration project"
        },
        "analysis": {
            "detectedSystems": [],
            "detectedProcesses": [],
            "missingInformation": [
                {
                    "item": "Test Missing Info Item",
                    "priority": "high",
                    "category": "Testing"
                }
            ]
        },
        "workflows": {},
        "actionItems": [
            {
                "title": "Test Action Item",
                "description": "This is a test action item",
                "priority": "medium",
                "category": "Testing",
                "dueInDays": 3
            }
        ],
        "metadata": {
            "systemCount": 0,
            "processCount": 0,
            "missingInfoCount": 1,
            "actionItemCount": 1,
            "source": "Webhook Test",
            "documentType": "IntegrationScope"
        }
    }

def main():
    """Main execution function"""

    # Check if webhook URL is provided
    if len(sys.argv) < 2:
        print("Usage: python test_webhook.py <webhook_url> [--custom]")
        print("\nExample:")
        print("  python test_webhook.py https://prod-123.eastus.logic.azure.com:443/...")
        print("  python test_webhook.py https://prod-123.eastus.logic.azure.com:443/... --custom")
        print("\nOptions:")
        print("  --custom    Use minimal custom payload instead of sample_webhook_payload.json")
        sys.exit(1)

    webhook_url = sys.argv[1]

    # Validate URL
    if not webhook_url.startswith('http'):
        print("Error: Webhook URL must start with http:// or https://")
        sys.exit(1)

    # Load or create payload
    use_custom = '--custom' in sys.argv

    if use_custom:
        print("Using custom minimal payload...")
        payload = create_custom_payload()
    else:
        print("Loading sample payload from file...")
        payload = load_sample_payload()

    # Send webhook
    send_webhook(webhook_url, payload)

if __name__ == "__main__":
    main()
