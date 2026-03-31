College Softball Scouting Dashboard (MEC_Scouting_Dashboard)

Overview
This project is an interactive scouting and lineup analysis dashboard built to evaluate player performance, lineup tendencies, and pitching/hitting trends throughout the season.

The dashboard is designed to support coaching decisions by providing insights into:
	•	Player performance trends
	•	Lineup optimization
	•	Position usage
	•	Recent form (last 5 games vs full season)

Key Features
	•	Lineup tendencies by batting spot
	•	Most frequent position per player
	•	Toggle between full season and last 5 games
	•	Pitching identification and analysis
	•	Player performance tracking (AVG, OBP, SLG, etc.)
	•	Dynamic filtering by team and game segments

Data Structure
Data is structured at the game level with the following key fields:
	•	Game_ID, Date, Team, Opponent
	•	Player Name
	•	Offensive stats (AB, H, RBI, BB, TB, etc.)
	•	Position (including multi-position entries such as LF/P, DP/P)
	•	Last5_Flag for recent performance analysis

How to Use
	1.	Select a team using the dashboard filter
	2.	Use the Last 5 toggle to switch between:
	    •	Full season data (FALSE)
	    •	Last 5 games (TRUE)
	3.	Review lineup tendencies to evaluate player positioning
	4.	Use player stats to compare performance across the lineup

Tools Used
	•	Microsoft Excel
	•	Data validation and dynamic formulas
	•	Conditional formatting
	•	Charts and visualizations

<img width="1440" height="871" alt="MEC_Scouting_Dashboard_Screenshot" src="https://github.com/user-attachments/assets/4bf9baa7-c458-45be-a4d5-454fc527561e" />
<img width="1440" height="872" alt="MEC_Scouting_Dashboard_Season_Screenshot" src="https://github.com/user-attachments/assets/e3ed9c0f-c9bc-4cd1-a19c-3723125e3926" />

Future Improvements
	•	Automate data updates
	•	Add more advanced visualizations
	•	Integrate predictive lineup optimization
	•	Expand pitching analysis metrics
