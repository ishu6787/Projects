
# -----------------------------
# California Housing Regression
# -----------------------------

# Import necessary libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import fetch_california_housing
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

# 1. Load and Explore Dataset
housing = fetch_california_housing()
X = pd.DataFrame(housing.data, columns=housing.feature_names)
y = pd.Series(housing.target, name="MedianHouseValue")

print("\n--- Dataset Info ---")
print(X.head())
print("\nTarget Variable:")
print(y.head())

# 2. Data Preparation
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Standardizing features (important for k-NN)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 3. Model Training

# Linear Regression Model
lr_model = LinearRegression()
lr_model.fit(X_train, y_train)
lr_preds = lr_model.predict(X_test)

# k-NN Regression Models (with k=3, 5, 7)
k_values = [3, 5, 7]
knn_results = {}

for k in k_values:
    knn = KNeighborsRegressor(n_neighbors=k)
    knn.fit(X_train_scaled, y_train)
    preds = knn.predict(X_test_scaled)
    knn_results[k] = preds

# 4. Model Evaluation Function
def evaluate_model(name, y_true, y_pred):
    print(f"\n{name} Performance:")
    print("R² Score:", round(r2_score(y_true, y_pred), 4))
    print("Mean Absolute Error:", round(mean_absolute_error(y_true, y_pred), 4))
    print("Mean Squared Error:", round(mean_squared_error(y_true, y_pred), 4))

# Evaluate Linear Regression
evaluate_model("Linear Regression", y_test, lr_preds)

# Evaluate k-NN for different k
for k in k_values:
    evaluate_model(f"k-NN Regression (k={k})", y_test, knn_results[k])

# 5. Visualization: Actual vs Predicted (Linear Regression)
plt.figure(figsize=(8, 5))
plt.scatter(y_test, lr_preds, alpha=0.5, color='blue')
plt.xlabel("Actual Median House Value")
plt.ylabel("Predicted Median House Value")
plt.title("Linear Regression: Actual vs Predicted")
plt.grid(True)
plt.show()

# Optional: Plot k vs R2
r2_scores = [r2_score(y_test, knn_results[k]) for k in k_values]
plt.figure(figsize=(6,4))
plt.plot(k_values, r2_scores, marker='o', linestyle='--', color='green')
plt.title("k-NN Regression: k vs R² Score")
plt.xlabel("k (Number of Neighbors)")
plt.ylabel("R² Score")
plt.grid(True)
plt.show()

