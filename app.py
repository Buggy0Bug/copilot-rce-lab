from flask import Flask, request, jsonify, render_template_string

app = Flask(__name__)

TEMPLATE = """
<html>
<head><title>Dashboard</title></head>
<body>
  <h1>Welcome {{ name }}</h1>
  <form action="/search" method="GET">
    <input name="q" placeholder="Search...">
    <button type="submit">Go</button>
  </form>
</body>
</html>
"""

@app.route("/")
def home():
    return render_template_string(TEMPLATE, name="User")

@app.route("/search")
def search():
    query = request.args.get("q", "")
    return jsonify({"query": query, "results": []})

@app.route("/api/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
