# 🚀 GitHub Random Repository Fetcher

Fetches a random popular GitHub repository for a given programming language using the GitHub API.

---

## 🎯 Features

* 🔍 Search GitHub repositories by language
* ⭐ Sorts by stars to get top repositories
* 🎲 Returns a random repo from top 100
* 📊 Displays stars, forks, open issues, description, and URL

---

## 🛠️ Tech Stack

* Java 17+
* Spring Boot (for `RestTemplate` and REST client)
* GitHub REST API v3

---

## 🚀 How to Use

1. Clone the repo:

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

2. Run the application:

   ```bash
   ./mvnw spring-boot:run
   ```

3. Call the service method `getRandomRepository(language)` with your desired language, e.g., `"Java"` or `"Python"`.

---

## 📋 Example Output

```json
{
  "name": "spring-boot",
  "description": "Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications.",
  "stars": 60000,
  "forks": 35000,
  "openIssues": 300,
  "url": "https://github.com/spring-projects/spring-boot",
  "language": "Java"
}
```

---

## ⚙️ Configuration

* Make sure your app has internet access to reach the GitHub API.
* Optionally add GitHub API token for higher rate limits (can be added via HTTP headers in `RestTemplate`).

---

## 🚧 Future Improvements

* Add caching to avoid hitting GitHub API rate limits 🔄
* Add error handling for API failures 🚨
* Add support for pagination and more filters 📚

---

## 🙌 Contributing

Feel free to open issues or submit PRs! Contributions are welcome! ✨

---

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## 🤝 Contact

Created by Mahee — [mahendraachari37@gmail.com](mailto:mahendraachari37@gmail.com)

---
https://roadmap.sh/projects/github-random-repo
