package com.example.githubfinder.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.githubfinder.dto.RepositoryDTO;
import com.example.githubfinder.service.GitHubService;

@RestController
@RequestMapping("/git")
public class RepoHandlingController {

    @Autowired
    private GitHubService gitService;

 
    @GetMapping("/repos")
    public RepositoryDTO getRepositoryByLanguage(@RequestParam String language) {
        return gitService.getRandomRepository(language);
    }

    
   
}
