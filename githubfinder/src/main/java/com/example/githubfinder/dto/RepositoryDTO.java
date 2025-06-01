package com.example.githubfinder.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RepositoryDTO {

    private String name;
    private String description;
    private int stars;
    private int forks;
    private int openIssues;
    private String url;
    private String language;


}
