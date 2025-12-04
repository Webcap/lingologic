"""
Script to generate SQL migration for adding Spanish translations to lessons.
This reads lesson data and generates UPDATE statements with Spanish translations.
"""

import json
import sys
from pathlib import Path

# Spanish translations mapping for common UI elements
COMMON_TRANSLATIONS = {
    "Basic Greetings": "Saludos Básicos",
    "Introducing Yourself": "Presentándote",
    "Starting a Conversation": "Iniciando una Conversación",
    "Sharing Personal Information": "Compartiendo Información Personal",
    "Nationality and Occupation": "Nacionalidad y Ocupación",
    "Contact Information": "Información de Contacto",
    "Putting It All Together": "Uniendo Todo",
    "Greetings and Farewells": "Saludos y Despedidas",
    "Making Requests": "Haciendo Peticiones",
    "Asking for Help": "Pidiendo Ayuda",
    "Apologizing": "Disculpándose",
    "Expressing Gratitude": "Expresando Gratitud",
    "Making Offers": "Haciendo Ofertas",
    "Making Suggestions": "Haciendo Sugerencias",
    "Polite Expressions": "Expresiones de Cortesía",
    # Add more common translations as needed
}

def translate_text_section(section, lesson_language):
    """Generate Spanish translations for a text section"""
    translations = {}
    
    if 'title' in section:
        # If it's an English lesson, translate the title
        if lesson_language == 'english':
            translations['title'] = COMMON_TRANSLATIONS.get(
                section['title'], 
                section['title']  # Keep original if no translation available
            )
    
    if 'content' in section:
        # For now, keep content as-is (would need manual translation)
        # translations['content'] = translate_content(section['content'])
        pass
    
    if 'examples' in section:
        # translations['examples'] = [translate_example(ex) for ex in section['examples']]
        pass
    
    return translations if translations else None

def generate_section_translations(sections, lesson_language):
    """Generate translations for all sections"""
    section_updates = []
    
    for idx, section in enumerate(sections):
        section_type = section.get('type')
        section_id = section.get('id')
        
        translations = {}
        
        if section_type == 'text':
            if 'title' in section:
                translations['title'] = COMMON_TRANSLATIONS.get(section['title'], section['title'])
            # Add content and examples translations here
        
        elif section_type == 'exercise':
            if 'instruction' in section:
                translations['instruction'] = section['instruction']  # Would need translation
            if 'question' in section:
                translations['question'] = section['question']  # Would need translation
            if 'explanation' in section:
                translations['explanation'] = section['explanation']  # Would need translation
            if 'hint' in section:
                translations['hint'] = section['hint']  # Would need translation
        
        elif section_type == 'matching':
            if 'instruction' in section:
                translations['instruction'] = section['instruction']
            if 'explanation' in section:
                translations['explanation'] = section['explanation']
        
        elif section_type == 'pronunciation':
            if 'instruction' in section:
                translations['instruction'] = section['instruction']
            if 'explanation' in section:
                translations['explanation'] = section['explanation']
        
        elif section_type == 'example':
            if 'explanation' in section:
                translations['explanation'] = section['explanation']
        
        if translations:
            section_updates.append({
                'index': idx,
                'section_id': section_id,
                'translations': translations
            })
    
    return section_updates

def generate_sql_migration(lessons_json):
    """Generate SQL UPDATE statements for lesson translations"""
    sql_statements = []
    
    sql_statements.append("-- Migration: Add Spanish translations to all English lessons")
    sql_statements.append("-- Generated automatically - review and update translations as needed")
    sql_statements.append("")
    
    for lesson in lessons_json:
        lesson_id = lesson['id']
        lesson_language = lesson['language']
        title = lesson['title']
        description = lesson['description']
        
        # Skip if not an English lesson (translations are for English lessons shown to Spanish speakers)
        if lesson_language != 'english':
            continue
        
        # Add lesson-level translations
        title_es = title  # Would need actual translation
        desc_es = description  # Would need actual translation
        
        sql_statements.append(f"-- Lesson: {lesson_id}")
        sql_statements.append(f"-- Original title: {title}")
        sql_statements.append(f"UPDATE lessons")
        sql_statements.append(f"SET content_json = jsonb_set(")
        sql_statements.append(f"  content_json,")
        sql_statements.append(f"  '{{translations}}',")
        sql_statements.append(f"  '{{\"es\": {{\"title\": \"{title_es}\", \"description\": \"{desc_es}\"}}}}'::jsonb")
        sql_statements.append(f")")
        sql_statements.append(f"WHERE id = '{lesson_id}';")
        sql_statements.append("")
        
        # Add section translations
        if 'content_json' in lesson and 'sections' in lesson['content_json']:
            sections = lesson['content_json']['sections']
            section_updates = generate_section_translations(sections, lesson_language)
            
            for update in section_updates:
                section_idx = update['index']
                section_id = update['section_id']
                translations_json = json.dumps(update['translations'], ensure_ascii=False)
                
                sql_statements.append(f"-- Section: {section_id}")
                sql_statements.append(f"UPDATE lessons")
                sql_statements.append(f"SET content_json = jsonb_set(")
                sql_statements.append(f"  content_json,")
                sql_statements.append(f"  '{{sections,{section_idx},translations}}',")
                sql_statements.append(f"  '{translations_json.replace(chr(39), chr(39)+chr(39))}'::jsonb")
                sql_statements.append(f")")
                sql_statements.append(f"WHERE id = '{lesson_id}';")
                sql_statements.append("")
    
    return "\n".join(sql_statements)

if __name__ == "__main__":
    # This is a template - in practice, you would:
    # 1. Load the lessons JSON from a file
    # 2. Add proper Spanish translations
    # 3. Generate the SQL
    print("This script generates SQL for lesson translations.")
    print("Load your lessons JSON and run this script to generate the migration file.")

