package com.example.githubfinder.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/git")
public class HomeController {

	 @GetMapping("/index")
	    public String showRepoFinderPage() {
	        return "index"; 
	    }
}
