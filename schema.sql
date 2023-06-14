CREATE TABLE countries (
        code VARCHAR NOT NULL, 
        name VARCHAR, 
        regions_count INTEGER, 
        users_count INTEGER, 
        wines_count INTEGER, 
        wineries_count INTEGER, 
        PRIMARY KEY (code)
);
CREATE TABLE grapes (
        id INTEGER NOT NULL, 
        name VARCHAR, 
        PRIMARY KEY (id)
);
CREATE TABLE wineries (
        id INTEGER NOT NULL, 
        name VARCHAR, 
        PRIMARY KEY (id)
);
CREATE TABLE flavor_groups (
        name VARCHAR NOT NULL, 
        PRIMARY KEY (name)
);
CREATE TABLE keywords (
        id INTEGER NOT NULL, 
        name VARCHAR, 
        PRIMARY KEY (id)
);
CREATE TABLE regions (
        id INTEGER NOT NULL, 
        name VARCHAR, 
        country_code VARCHAR, 
        PRIMARY KEY (id), 
        FOREIGN KEY(country_code) REFERENCES countries (code)
);
CREATE TABLE most_used_grapes_per_country (
        id INTEGER NOT NULL, 
        country_code VARCHAR, 
        grape_id INTEGER, 
        wines_count INTEGER, 
        PRIMARY KEY (id), 
        FOREIGN KEY(country_code) REFERENCES countries (code), 
        FOREIGN KEY(grape_id) REFERENCES grapes (id)
);
CREATE TABLE toplists (
        id INTEGER NOT NULL, 
        name VARCHAR(255) NOT NULL, 
        country_code VARCHAR, 
        PRIMARY KEY (id), 
        FOREIGN KEY(country_code) REFERENCES countries (code)
);
CREATE TABLE wines (
        id INTEGER NOT NULL, 
        name VARCHAR, 
        is_natural BOOLEAN, 
        region_id INTEGER, 
        winery_id INTEGER, 
        ratings_average FLOAT, 
        ratings_count INTEGER, 
        url VARCHAR, 
        acidity FLOAT, 
        fizziness FLOAT, 
        intensity FLOAT, 
        sweetness FLOAT, 
        tannin FLOAT, 
        user_structure_count INTEGER, 
        PRIMARY KEY (id), 
        FOREIGN KEY(region_id) REFERENCES regions (id), 
        FOREIGN KEY(winery_id) REFERENCES wineries (id)
);
CREATE TABLE vintages (
        id INTEGER NOT NULL, 
        name VARCHAR, 
        wine_id INTEGER, 
        ratings_average FLOAT, 
        ratings_count INTEGER, 
        year INTEGER, 
        price_euros FLOAT, 
        price_discounted_from FLOAT, 
        price_discount_percentage FLOAT, 
        bottle_volume_ml INTEGER, 
        PRIMARY KEY (id), 
        FOREIGN KEY(wine_id) REFERENCES wines (id)
);
CREATE TABLE keywords_wine (
        keyword_id INTEGER NOT NULL, 
        wine_id INTEGER NOT NULL, 
        group_name VARCHAR NOT NULL, 
        keyword_type VARCHAR, 
        count INTEGER, 
        PRIMARY KEY (keyword_id, wine_id, group_name), 
        FOREIGN KEY(keyword_id) REFERENCES keywords (id), 
        FOREIGN KEY(wine_id) REFERENCES wines (id)
);
CREATE TABLE vintage_toplists_rankings (
        id INTEGER NOT NULL, 
        top_list_id INTEGER, 
        vintage_id INTEGER, 
        rank INTEGER, 
        previous_rank INTEGER, 
        PRIMARY KEY (id), 
        FOREIGN KEY(top_list_id) REFERENCES toplists (id), 
        FOREIGN KEY(vintage_id) REFERENCES vintages (id)
);