from flask import Flask, jsonify
import logging

# Initialize Flask app
app = Flask(__name__)

# Configure logging 
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

@app.route("/")
def index():
    app.logger.info("Root endpoint accessed")
    return "Hello from your EC2 instance!"

@app.route("/health")
def health():
    app.logger.info("Health check endpoint accessed")
    return jsonify(status="ok")

@app.route("/info")
def info():
    app.logger.info("Info endpoint accessed")
    return jsonify(
        app="Python EC2 Flask App",
        version="1.0",
        environment="production"
    )

if __name__ == "__main__":
    # Run the app on all interfaces, port 8000
    app.run(host="0.0.0.0", port=8000)
