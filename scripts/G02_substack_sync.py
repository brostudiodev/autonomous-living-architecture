import feedparser
import requests
from bs4 import BeautifulSoup
import os
import re
from datetime import datetime

# Configuration
SUBSTACK_URL = "https://automationbro.substack.com/feed"
OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
SUBSTACK_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "04_Resources/Automationbro/Articles")

def clean_filename(filename):
    return re.sub(r'[\/*?:"<>|]', "", filename)

def fetch_substack_posts():
    print(f"Checking Substack feed: {SUBSTACK_URL}")
    feed = feedparser.parse(SUBSTACK_URL)
    posts = []
    
    for entry in feed.entries:
        posts.append({
            "title": entry.title,
            "link": entry.link,
            "date": entry.published,
            "id": entry.id,
            "content": entry.description # Usually the full content or summary in RSS
        })
    return posts

def sync_posts_to_obsidian():
    if not os.path.exists(SUBSTACK_NOTES_DIR):
        os.makedirs(SUBSTACK_NOTES_DIR)
        
    posts = fetch_substack_posts()
    synced_count = 0
    
    for post in posts:
        filename = clean_filename(post['title']) + ".md"
        file_path = os.path.join(SUBSTACK_NOTES_DIR, filename)
        
        if not os.path.exists(file_path):
            print(f"Creating local copy for: {post['title']}")
            
            # Simple HTML to Markdown-ish conversion
            soup = BeautifulSoup(post['content'], 'html.parser')
            text_content = soup.get_text(separator='\n')
            
            # Create Markdown with Frontmatter
            md_content = f"""---
title: "{post['title']}"
link: {post['link']}
date: {post['date']}
source: substack
tags: [article, automationbro]
---

# {post['title']}

Original Link: {post['link']}
Published: {post['date']}

---

{text_content}
"""
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(md_content)
            synced_count += 1
            
    print(f"✅ Substack Sync Complete. {synced_count} new articles added to Obsidian.")
    return posts

if __name__ == "__main__":
    sync_posts_to_obsidian()
