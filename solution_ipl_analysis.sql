use ipl;




# Q1 - WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?

SELECT 
    player_of_match, COUNT(*) AS awards_count
FROM
    matches
GROUP BY player_of_match
ORDER BY awards_count DESC
LIMIT 5;




# Q2. - HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?

SELECT 
    season, winner AS team, COUNT(*) AS match_won
FROM
    matches
GROUP BY season , winner;




# Q3 - WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?

SELECT 
    AVG(strike_rate) AS avg_strike_rate
FROM
    (SELECT 
        batsman,
            (SUM(total_runs) / COUNT(ball)) * 100 AS strike_rate
    FROM
        deliveries
    GROUP BY batsman) AS bats_stat;
    
SELECT 
    batsman,
    (SUM(total_runs) / COUNT(ball)) * 100 AS strike_rate
FROM
    deliveries
GROUP BY batsman;
    
    


# Q4 - WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND?

SELECT 
    batting_first, COUNT(*) matches_won
FROM
    (SELECT 
        CASE
                WHEN win_by_runs > 0 THEN team1
                ELSE team2
            END AS batting_first
    FROM
        matches
    WHERE
        winner != 'Tie') AS batting_first_team
GROUP BY batting_first;

SELECT 
    CASE
        WHEN win_by_runs > 0 THEN team1
        ELSE team2
    END AS batting_first
FROM
    matches
WHERE
    winner != 'Tie';
    
    
    
    
# Q5 - WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?

SELECT 
    batsman, (SUM(batsman_runs) * 100 / COUNT(*)) AS strike_rate
FROM
    deliveries
GROUP BY batsman
HAVING SUM(batsman_runs) >= 200
ORDER BY strike_rate DESC
LIMIT 1;




# Q6 - HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?

SELECT 
    batsman, COUNT(*) AS total_dismissal
FROM
    deliveries
WHERE
    player_dismissed IS NOT NULL
        AND bowler = 'SL Malinga'
GROUP BY batsman;




# Q7 - WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?

SELECT 
    batsman,
    AVG(CASE
        WHEN batsman_runs = 4 OR batsman_runs = 6 THEN 1
        ELSE 0
    END)*100 AS avg_boundaries
FROM
    deliveries
GROUP BY batsman;




# Q8 - WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?

SELECT 
    season,
    batting_team,
    AVG(fours + sixes) AS average_boundaries
FROM
    (SELECT 
        season,
            match_id,
            batting_team,
            SUM(CASE
                WHEN batsman_runs = 4 THEN 1
                ELSE 0
            END) AS fours,
            SUM(CASE
                WHEN batsman_runs = 6 THEN 1
                ELSE 0
            END) AS sixes
    FROM
        deliveries, matches
    WHERE
        deliveries.match_id = matches.id
    GROUP BY season , match_id , batting_team) AS team_boundaries
GROUP BY season , batting_team;


SELECT 
    season,
    match_id,
    batting_team,
    SUM(CASE
        WHEN batsman_runs = 4 THEN 1
        ELSE 0
    END) AS fours,
    SUM(CASE
        WHEN batsman_runs = 6 THEN 1
        ELSE 0
    END) AS sixes
FROM
    deliveries,
    matches
WHERE
    deliveries.match_id = matches.id
GROUP BY season , match_id , batting_team;




# Q9 - WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?

SELECT 
    season, batting_team, MAX(total_runs) AS highest_partership
FROM
    (SELECT 
        season,
            batting_team,
            partnership,
            SUM(total_runs) AS total_runs
    FROM
        (SELECT 
        season,
            match_id,
            batting_team,
            over_no,
            SUM(batsman_runs) AS partnership,
            SUM(batsman_runs) + SUM(extra_runs) AS total_runs
    FROM
        deliveries, matches
    WHERE
        deliveries.match_id = matches.id
    GROUP BY season , match_id , batting_team , over_no) AS team_score
    GROUP BY season , batting_team , partnership) AS highest_partnership
GROUP BY season , batting_team;



SELECT 
    season,
    batting_team,
    partnership,
    SUM(total_runs) AS total_runs
FROM
    (SELECT 
        season,
            match_id,
            batting_team,
            over_no,
            SUM(batsman_runs) AS partnership,
            SUM(batsman_runs) + SUM(extra_runs) AS total_runs
    FROM
        deliveries, matches
    WHERE
        deliveries.match_id = matches.id
    GROUP BY season , match_id , batting_team , over_no) AS team_score
GROUP BY season , batting_team , partnership;

SELECT 
        season,
            match_id,
            batting_team,
            over_no,
            SUM(batsman_runs) AS partnership,
            SUM(batsman_runs) + SUM(extra_runs) AS total_runs
    FROM
        deliveries, matches
    WHERE
        deliveries.match_id = matches.id
    GROUP BY season , match_id , batting_team , over_no;
    
    
    
    
    
# Q10 - HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?

SELECT 
    m.id AS match_no,
    d.bowling_team,
    SUM(d.extra_runs) AS extras
FROM
    matches AS m
        JOIN
    deliveries AS d ON d.match_id = m.id
WHERE
    extra_runs > 0
GROUP BY m.id , d.bowling_team;




# Q11 - WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?

SELECT 
    m.id AS match_no, d.bowler, COUNT(*) AS wicket_taken
FROM
    matches AS m
        JOIN
    deliveries AS d ON d.match_id = m.id
WHERE
    d.player_dismissed IS NOT NULL
GROUP BY m.id , d.bowler
ORDER BY wicket_taken DESC
LIMIT 1;




# Q12 - HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?

SELECT 
    m.city,
    CASE
        WHEN m.team1 = m.winner THEN m.team1
        WHEN m.team2 = m.winner THEN m.team2
        ELSE 'draw'
    END AS winning_team,
    COUNT(*) AS wins
FROM
    matches AS m
        JOIN
    deliveries AS d ON d.match_id = m.id
WHERE
    m.result != 'Tie'
GROUP BY m.city , winning_team;





# Q13 - HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?

SELECT 
    season, toss_winner, COUNT(*) AS toss_wins
FROM
    matches
GROUP BY season , toss_winner;





# Q14 - HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?

SELECT 
    player_of_match, COUNT(*) AS total_wins
FROM
    matches
WHERE
    player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY total_wins DESC;




# Q15 - WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?

SELECT 
    m.id,
    d.inning,
    d.over_no,
    AVG(d.total_runs) AS average_runs_per_over
FROM
    matches AS m
        JOIN
    deliveries AS d ON d.match_id = m.id
GROUP BY m.id , d.inning , d.over_no;




# Q16 - WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

SELECT 
    m.season,
    m.id AS match_no,
    d.batting_team,
    SUM(d.total_runs) AS total_score
FROM
    matches AS m
        JOIN
    deliveries AS d ON d.match_id = m.id
GROUP BY m.season , m.id , d.batting_team
ORDER BY total_score DESC
LIMIT 1;




# Q17 - WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?

SELECT 
    m.season,
    m.id AS match_no,
    d.batsman,
    SUM(d.batsman_runs) AS total_runs
FROM
    matches AS m
        JOIN
    deliveries AS d ON d.match_id = m.id
GROUP BY m.season , m.id , d.batsman
ORDER BY total_runs DESC
LIMIT 1;