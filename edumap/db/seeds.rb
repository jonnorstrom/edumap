require 'csv'
=begin
def resource_path(resource)
  'db/mappings/seed' + resource
end
=end

def standard_parser(file)
  resource_path = 'db/seeds'
  CSV.foreach(Rails.root.join(resource_path, file)) do |result|
    standard = Standard.find_or_create_by(name: result[0], abbreviation: result[1])
  end
end

def code_parser(file)
  resource_path = 'db/seeds'
  CSV.foreach(Rails.root.join(resource_path, file)) do |result|
    standard = Standard.find_or_create_by(abbreviation: result[2])
    code = Code.find_or_create_by(identifier: result[0], description: result[1], standard: standard)
  end
end

def level_parser(file)
  resource_path = 'db/seeds'
  CSV.foreach(Rails.root.join(resource_path, file)) do |result|
    level = Level.find_or_create_by(grade: result[0])
  end
end

def lesson_parser(file)
  resource_path = 'db/seeds'
  CSV.foreach(Rails.root.join(resource_path, file)) do |result|
    curriculum = Curriculum.find_or_create_by(name: result[1])
    standard = Standard.find_or_create_by(abbreviation: result[3])
    code = Code.find_or_create_by(identifier: result[4], standard: standard)
    lesson = Lesson.find_or_create_by(name: result[2], curriculum: curriculum, lesson_url: result[0])
    unless lesson.codes.exists?(identifier: result[4])
      lesson.codes << code
    end
    unless lesson.standards.exists?(abbreviation: result[3])
      lesson.standards << standard
    end
    unless lesson.levels.exists?(grade: result[5].to_i.ordinalize)
      lesson.levels << Level.find_or_create_by(grade: result[5].to_i.ordinalize)
    end
  end
end

def ct_stem_parser(file)
  resource_path = 'db/mappings/seed'
  CSV.foreach(Rails.root.join(resource_path, file)) do |result|
    curriculum = Curriculum.find_or_create_by(name: "Northwestern CT-STEM", curriculum_url: "http://ct-stem.northwestern.edu/lesson-plans/")
    lesson = Lesson.find_or_create_by(name: result[0], curriculum: curriculum)
    lesson.lesson_url = result.last
  end
end

=begin
def parser(file, resource)
  standard_parser = file.split(".")[0]
  curriculum = Curriculum.find_or_create_by(name: resource)
  standard = Standard.find_or_create_by(name: standard_parser)
  CSV.foreach(Rails.root.join(resource_path(resource), file)) do |result|
    lesson = curriculum.lessons.find_or_create_by(name: result[0])
    code = lesson.codes.find_or_create_by(name:result[1])
    standard.codes << code

    # standard_info = info[1].split(".")
    # standard = Standard.find_or_create_by(name:resource)
    # proficiency = standard.proficiencies.find_or_create_by(name:standard_info[0])
    # level = proficiency.levels.find_or_create_by(name:standard_info[1])
  end
end

parser("CSTA.csv","code.org")
=end

standard_parser("standards/standards.csv")
code_parser("standards/ngss_topics.csv")
code_parser("standards/CSTA_codes.csv")
code_parser("standards/CC_Codes.csv")
code_parser("standards/ISTE_codes.csv")
level_parser("levels/levels.csv")
lesson_parser("lessons/code_org_lessons.csv")

# write code to get the standard in the file
