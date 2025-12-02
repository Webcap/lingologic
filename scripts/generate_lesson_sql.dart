import 'dart:convert';
import 'dart:io';
import '../lib/data/seed/spanish_lessons.dart';

void main() {
  final lessons = SpanishLessons.getLessons();
  final sql = StringBuffer();
  
  sql.writeln('-- Seed data for Spanish grammar lessons');
  sql.writeln('-- Run this after 002_add_lessons.sql migration');
  sql.writeln('-- Generated automatically from lib/data/seed/spanish_lessons.dart');
  sql.writeln('');
  
  for (final lesson in lessons) {
    final contentJson = jsonEncode(lesson.content.toJson());
    // Escape single quotes for SQL
    final escapedContent = contentJson.replaceAll("'", "''");
    
    sql.writeln('-- ${lesson.title}');
    sql.writeln('INSERT INTO lessons (id, title, description, language, category, order_index, estimated_minutes, content_json, unlocks_word_ids, unlocks_grammar_concepts)');
    sql.writeln('VALUES (');
    sql.writeln("  '${lesson.id}',");
    sql.writeln("  '${lesson.title.replaceAll("'", "''")}',");
    sql.writeln(lesson.description != null 
        ? "  '${lesson.description!.replaceAll("'", "''")}',"
        : "  NULL,");
    sql.writeln("  '${lesson.language}',");
    sql.writeln(lesson.category != null 
        ? "  '${lesson.category}',"
        : "  NULL,");
    sql.writeln("  ${lesson.orderIndex},");
    sql.writeln("  ${lesson.estimatedMinutes},");
    sql.writeln("  '${escapedContent}'::jsonb,");
    sql.writeln("  ARRAY[${lesson.unlocksWordIds.map((w) => "'$w'").join(', ')}]::TEXT[],");
    sql.writeln("  ARRAY[${lesson.unlocksGrammarConcepts.map((c) => "'$c'").join(', ')}]::TEXT[]");
    sql.writeln(') ON CONFLICT (id) DO UPDATE SET');
    sql.writeln('  title = EXCLUDED.title,');
    sql.writeln('  description = EXCLUDED.description,');
    sql.writeln('  estimated_minutes = EXCLUDED.estimated_minutes,');
    sql.writeln('  content_json = EXCLUDED.content_json,');
    sql.writeln('  unlocks_word_ids = EXCLUDED.unlocks_word_ids,');
    sql.writeln('  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,');
    sql.writeln('  updated_at = NOW();');
    sql.writeln('');
  }
  
  // Get the project root directory (parent of scripts directory)
  final scriptDir = Directory.current;
  final projectRoot = scriptDir.path.endsWith('scripts') 
      ? scriptDir.parent 
      : scriptDir;
  
  final outputFile = File('${projectRoot.path}/supabase/seed_lessons.sql');
  outputFile.writeAsStringSync(sql.toString());
  print('Generated ${outputFile.path}');
  print('Generated SQL for ${lessons.length} lessons');
  print('First lesson estimated minutes: ${lessons.first.estimatedMinutes}');
}

