<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Repository Finder</title>
    <%-- Font Awesome for icons (GitHub, Star, Fork, Issues) --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* General Styles */
        body {
            font-family: -apple-system, BlinkMacMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f6f8fa;
            margin: 20px;
            display: flex;
            flex-direction: column;
            gap: 40px; /* Space between main dropdown and content area */
            align-items: center; /* Center content horizontally */
        }

        /* New: Main Application Header Container */
        .app-header-container {
            width: 320px; /* Match card width for dropdown alignment */
            display: flex;
            flex-direction: column;
            align-items: center; /* Center the icon and text */
            margin-bottom: 20px; /* Space between this header and the dynamic content area */
        }

        /* Card Header (reused for app header) */
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px; /* Space below header in app header */
            justify-content: center; /* Center the header content */
        }

        .card-header .github-icon {
            font-size: 24px;
            margin-right: 10px;
            color: #24292e; /* GitHub dark color */
        }

        .card-header h3 {
            margin: 0;
            font-size: 18px;
            color: #24292e;
        }

        /* Main Dropdown Container - placed directly under the app header */
        .main-dropdown-container { /* Renamed for clarity */
            width: 100%; /* Take full width of parent (.app-header-container) */
            margin-bottom: 0; /* No margin below if directly above dynamic content */
            position: relative;
        }

        /* Container for the dynamically displayed content cards */
        .dynamic-content-area {
            display: flex;
            justify-content: center; /* Center the card within this area */
            width: 100%;
            max-width: 360px; /* Max width for the content card, slightly larger than card itself */
        }

        .card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 320px; /* Fixed width for the cards as per screenshot */
            box-sizing: border-box; /* Include padding and border in the element's total width and height */
            border: 1px solid #e1e4e8;
        }

        /* Dropdown Styles (applies to main dropdown and disabled ones in cards) */
        .dropdown {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d5da;
            border-radius: 6px;
            background-color: #f6f8fa; /* Light background for dropdown */
            color: #24292e;
            font-size: 14px;
            appearance: none; /* Remove default arrow */
            -webkit-appearance: none;
            -moz-appearance: none;
            /* Custom arrow SVG */
            background-image: url('data:image/svg+xml;utf8,<svg fill="%2324292e" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 8px top 50%;
            background-size: 16px;
            cursor: pointer;
        }
        .dropdown:disabled {
            background-color: #e9ecef; /* Lighter background for disabled */
            cursor: not-allowed;
        }

        /* Placeholder / State Boxes */
        .state-box {
            background-color: #f6f8fa;
            border: 1px solid #e1e4e8;
            border-radius: 6px;
            padding: 40px 20px;
            text-align: center;
            color: #586069;
            font-size: 14px;
        }

        .state-box.error {
            background-color: #ffeef0; /* Light red */
            border-color: #ffdce0; /* Slightly darker red border */
            color: #cb2431; /* Dark red text */
        }
        .state-box.no-results {
            background-color: #fff9e6; /* Light yellow/orange for no results */
            border-color: #ffeb99;
            color: #8a6d3b;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            width: 100%;
            padding: 8px 12px;
            font-size: 14px;
            font-weight: 600;
            line-height: 20px;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            cursor: pointer;
            border: 1px solid transparent;
            border-radius: 6px;
            user-select: none;
            transition: background-color 0.2s ease-in-out, border-color 0.2s ease-in-out;
            margin-top: 15px; /* Spacing for buttons below state-box/repo-card */
        }
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-primary {
            color: #fff;
            background-color: black; /* Green */
            border-color: #2ea44f;
        }
        .btn-primary:hover:not(:disabled) {
            background-color: #2c974b;
            border-color: #2c974b;
        }

        .btn-danger {
            color: #fff;
            background-color: #cb2431; /* Red */
            border-color: #cb2431;
        }
        .btn-danger:hover:not(:disabled) {
            background-color: #c01c2c;
            border-color: #c01c2c;
        }

        /* Repository Card Styles */
        .repo-card-content {
            background-color: #fff;
            border: 1px solid #e1e4e8;
            border-radius: 6px;
            padding: 15px;
            text-align: left;
        }

        .repo-name {
            font-size: 16px;
            font-weight: 600;
            color: #0366d6; /* GitHub link blue */
            margin-bottom: 5px;
            text-decoration: none; /* Remove underline for links */
        }
        .repo-name:hover {
            text-decoration: underline; /* Add underline on hover */
        }

        .repo-description {
            font-size: 13px;
            color: #586069;
            margin-bottom: 10px;
            line-height: 1.5;
        }

        .repo-meta {
            display: flex;
            align-items: center;
            font-size: 12px;
            color: #586069;
            gap: 15px;
        }

        .repo-meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .repo-meta i {
            color: #586069; /* Icon color */
        }

        /* Language color dots - you'd dynamically set the background-color */
        .repo-meta .lang-color {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #f1e05a; /* Default; will be set by JS */
        }

        .external-link-section {
            font-size: 14px;
            color: #586069;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px dashed #e1e4e8; /* Dashed line */
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .external-link-section::before {
            content: "→"; /* Arrow character */
            font-size: 18px;
            color: #586069;
        }

        .refresh-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px dashed #e1e4e8;
            display: flex;
            flex-direction: column;
            gap: 15px;
            align-items: flex-start; /* Align text to start */
        }

        .refresh-section .refresh-text {
            font-size: 14px;
            color: #586069;
        }
        
        /* Helper class for JavaScript to toggle visibility */
        .hidden {
            display: none !important; /* Use !important to ensure override */
        }
    </style>
</head>
<body>

    <%-- Main Application Header (centralized and permanent) --%>
    <div class="app-header-container">
        <div class="card-header">
            <i class="fab fa-github github-icon"></i>
            <h3>GitHub Repository Finder</h3>
        </div>
        <%-- Main Language Dropdown (moved here) --%>
        <div class="main-dropdown-container">
            <label for="languageSelect" class="hidden">Choose Language:</label>
            <select name="language" id="languageSelect" class="dropdown" onchange="fetchRepo(this.value)">
                <option value="">-- Select a Language --</option>
                <option value="javascript">JavaScript</option>
                <option value="java">Java</option>
                <option value="python">Python</option>
                <option value="csharp">C#</option>
                <option value="go">Go</option>
                <option value="ruby">Ruby</option>
                <option value="php">PHP</option>
                <option value="typescript">TypeScript</option>
                <!-- <option value="errorStateCard">Error</option> -->
                <option value="swift">Swift</option>
                <option value="kotlin">Kotlin</option>
                <option value="c++">C++</option>
            </select>
        </div>
    </div>

    <div class="dynamic-content-area">
        <%-- All content states are here, initially hidden by the 'hidden' class, and managed by JavaScript --%>

        <div class="card hidden" id="emptyStateCard">
            <div class="state-box">
                Please select a language
            </div>
        </div>

        <div class="card hidden" id="loadingStateCard">
            <div class="state-box">
                Loading, please wait..
            </div>
        </div>

        <div class="card hidden" id="errorStateCard">
            <div class="state-box error">
                <span id="errorMessageText">Error fetching repositories</span>
            </div>
            <button type="button" class="btn btn-danger" id="retryButton">Click to retry</button>
        </div>

        <div class="card hidden" id="noResultsStateCard">
            <div class="state-box no-results">
                No repositories found for this language.
            </div>
            <button type="button" class="btn btn-primary" id="noResultsRetryButton">Select another language</button>
        </div>

        <div class="card hidden" id="contentStateCard">
            <div class="repo-card-content">
                <a href="#" id="repoUrl" target="_blank" class="repo-name">Repository Name</a>
                <div class="repo-description" id="repoDescription">Repository Description goes here.</div>
                <div class="repo-meta">
                    <span>
                        <span class="lang-color" id="repoLangColor"></span> <span id="repoLanguage">Language</span>
                    </span>
                    <span>
                        <i class="fa-solid fa-star"></i> <span id="repoStars">0</span>
                    </span>
                    <span>
                        <i class="fa-solid fa-code-branch"></i> <span id="repoForks">0</span>
                    </span>
                    <span>
                        <i class="fa-solid fa-circle-exclamation"></i> <span id="repoIssues">0</span>
                    </span>
                </div>
            </div>
           <!--  <div class="external-link-section">
                A random repository found using GitHub search API
            </div>
 -->
            <div class="refresh-section">
                <button type="button" class="btn btn-primary" id="refreshButton">Refresh</button>
                <span class="refresh-text">Refresh to Fetch another random repository for the selected language</span>
            </div>
        </div>
    </div>

<script>
        // --- DOM Element References ---
        const languageSelect = document.getElementById('languageSelect');
        const refreshButton = document.getElementById('refreshButton');
        const retryButton = document.getElementById('retryButton');
        const noResultsRetryButton = document.getElementById('noResultsRetryButton');

        // State Cards
        const emptyStateCard = document.getElementById('emptyStateCard');
        const loadingStateCard = document.getElementById('loadingStateCard');
        const errorStateCard = document.getElementById('errorStateCard');
        const noResultsStateCard = document.getElementById('noResultsStateCard');
        const contentStateCard = document.getElementById('contentStateCard');

        // Content Card Elements
        const repoUrl = document.getElementById('repoUrl');
        const repoDescription = document.getElementById('repoDescription');
        const repoLanguage = document.getElementById('repoLanguage');
        const repoLangColor = document.getElementById('repoLangColor');
        const repoStars = document.getElementById('repoStars');
        const repoForks = document.getElementById('repoForks');
        const repoIssues = document.getElementById('repoIssues');
        const errorMessageText = document.getElementById('errorMessageText');

        // All dropdowns inside dynamic cards (used for mirroring selection and disabling)
        const disabledDropdowns = document.querySelectorAll('.card .dropdown');

        // --- Language Colors Map (add more as needed) ---
        const languageColors = {
            "java": "#b07219",
            "python": "#3572A5",
            "javascript": "#f1e05a",
            "csharp": "#178600",
            "go": "#00ADD8",
            "ruby": "#701516",
            "php": "#4F5D95",
            "typescript": "#2b7489",
            "swift": "#ffac45",
            "kotlin": "#F18E33",
            "c++": "#f34b7d",
            "unknown": "#ccc" // Fallback color
        };

        // --- State Management Function ---
        function showCard(cardToShow) {
            // Hide all cards first
            [emptyStateCard, loadingStateCard, errorStateCard, noResultsStateCard, contentStateCard].forEach(card => {
                card.classList.add('hidden');
            });
            // Show the selected card
            cardToShow.classList.remove('hidden');

            // Update disabled dropdowns to reflect the current selection (if any)
            const selectedOptionText = languageSelect.options[languageSelect.selectedIndex]?.textContent || '-- Select a Language --';
            disabledDropdowns.forEach(dropdown => {
                if (dropdown.options.length > 0) { // Ensure there's at least one option
                    dropdown.options[0].textContent = selectedOptionText;
                }
            });
        }

        // --- Data Population Function ---
        function populateRepoCard(data) {
            repoUrl.textContent = data.name || "Repository Name";
            repoUrl.href = data.url || "#";
            repoDescription.textContent = data.description || "No description provided.";
            
            const lang = data.language || 'Unknown';
            repoLanguage.textContent = lang;
            const normalizedLang = lang.toLowerCase();
            repoLangColor.style.backgroundColor = languageColors[normalizedLang] || languageColors['unknown'];

            repoStars.textContent = (data.stars !== undefined && data.stars !== null) ? data.stars.toLocaleString() : '0';
            repoForks.textContent = (data.forks !== undefined && data.forks !== null) ? data.forks.toLocaleString() : '0';
            repoIssues.textContent = (data.openIssues !== undefined && data.openIssues !== null) ? data.openIssues.toLocaleString() : '0';
        }

        // --- API Call Logic (AJAX) ---
        async function fetchRepo(language) {
            // Reset error/no-results messages
            errorMessageText.textContent = 'Error fetching repositories';

            // Validate language selection
            if (!language || language === '') {
                showCard(emptyStateCard);
                return;
            }

            // Show loading state and disable main dropdown
            showCard(loadingStateCard);
            languageSelect.disabled = true;

            try {
                // MODIFICATION HERE: Use string concatenation instead of template literal
                // This prevents the JSP engine from trying to parse `encodeURIComponent` as EL.
                const response = await fetch('/git/repos?language=' + encodeURIComponent(language));

                if (!response.ok) {
                    const errorBody = await response.text(); // Get potential error message from server
                    errorMessageText.textContent = `Server responded with status ${response.status} (${response.statusText}). Error: ${errorBody.substring(0, Math.min(errorBody.length, 200))}...`;
                    showCard(errorStateCard);
                    console.error('API Error:', response.status, response.statusText, errorBody);
                    return;
                }

                const repoData = await response.json(); // Parse the JSON response

                if (!repoData || Object.keys(repoData).length === 0 || !repoData.name) {
                    showCard(noResultsStateCard);
                } else {
                    populateRepoCard(repoData);
                    showCard(contentStateCard);
                }

            } catch (error) {
                if (error instanceof SyntaxError) {
                    errorMessageText.textContent = `Error parsing server response (not valid JSON). This often means the server returned an error page.`;
                } else {
                    errorMessageText.textContent = `Network error: Could not connect to the server or unexpected issue: ${error.message}`;
                }
                showCard(errorStateCard);
                console.error('Fetch/Parsing error:', error);
            } finally {
                languageSelect.disabled = false;
            }
        }

        // --- Event Listeners ---

        refreshButton.addEventListener('click', () => {
            fetchRepo(languageSelect.value);
        });

        retryButton.addEventListener('click', () => {
            fetchRepo(languageSelect.value);
        });

        noResultsRetryButton.addEventListener('click', () => {
            languageSelect.value = '';
            showCard(emptyStateCard);
        });

        // --- Initial Page Load State ---
        document.addEventListener('DOMContentLoaded', () => {
            languageSelect.value = '';
            showCard(emptyStateCard);
        });
    </script>
</body>
</html>