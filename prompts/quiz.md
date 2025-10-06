Generate a quiz question from a random markdown file in the Obsidian vault located at ~/uuta.

## Process
1. Find all markdown files in ~/uuta (excluding personal notes, drafts, and temporary files)
2. Select a random file from the available options
3. Read and analyze the content structure
4. Generate an appropriate quiz question based on the content type:
   - For structured content (headings, lists): Create organizational or categorization questions
   - For definitions and concepts: Create explanation or definition questions  
   - For technical content (code, procedures): Create application or sequence questions
   - For factual information: Create recall or comprehension questions

## Question Types
- Multiple choice (when content has clear categories or options)
- Short answer (for definitions or explanations)
- Fill-in-the-blank (for key terms or missing steps)
- True/False (for factual statements)

## Content Filtering
- Exclude files matching these patterns: Personal/, Drafts/, *TODO*, *temp*
- Prioritize files with structured content (headers, lists, code blocks, emphasis)
- Ensure minimum content length for meaningful questions

## Parameters
- `--count=N`: Generate N questions (default: 1)
- `--type=TYPE`: Focus on specific question type (multiple-choice, short-answer, etc.)
- `--difficulty=LEVEL`: Adjust complexity (basic, intermediate, advanced)
- `--include=PATTERN`: Include only files matching pattern
- `--exclude=PATTERN`: Exclude files matching pattern

## Output Format
Present the question clearly, wait for user response, then provide the answer with explanation and reference to the source file and location.