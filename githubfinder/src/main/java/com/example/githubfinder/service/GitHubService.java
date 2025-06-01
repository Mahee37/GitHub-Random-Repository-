package com.example.githubfinder.service;

import com.example.githubfinder.dto.RepositoryDTO;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;
import java.util.Random;

@Service
public class GitHubService {

    private final RestTemplate restTemplate = new RestTemplate();


    public RepositoryDTO getRandomRepository(String language) {
        String url = "https://api.github.com/search/repositories?q=language:" + language + "&sort=stars&order=desc&per_page=100";

        Map response = restTemplate.getForObject(url, Map.class);
        List<Map<String, Object>> items = (List<Map<String, Object>>) response.get("items");

        if (items == null || items.isEmpty()) {
            return null;
        }

        Map<String, Object> repo = items.get(new Random().nextInt(items.size()));

        RepositoryDTO dto = new RepositoryDTO();
        dto.setName((String) repo.get("name"));
        dto.setDescription((String) repo.get("description"));
        dto.setStars(((Number) repo.get("stargazers_count")).intValue());
        dto.setForks(((Number) repo.get("forks_count")).intValue());
        dto.setOpenIssues(((Number) repo.get("open_issues_count")).intValue());
        dto.setUrl((String) repo.get("html_url"));
        dto.setLanguage((String) repo.get("language")); 

        return dto;
    }

}
