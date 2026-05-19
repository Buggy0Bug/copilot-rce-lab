.PHONY: build test run clean

build:
	pip install -r requirements.txt

test:
	python -m pytest tests/ -v

run:
	python app.py

clean:
	find . -name "*.pyc" -delete
	rm -rf __pycache__
