# [JamPack](https://jampack.vercel.app/)
![JamPack icon](https://github.com/user-attachments/assets/cdef9412-651b-43f5-92a0-139b175c7d83)

**JamPack** is a lightweight macOS utility that merges any number of code files into a **single .txt file** — ideal for feeding large projects into AI assistants like ChatGPT, Claude, Gemini, or archiving cleanly.

🔗 [Click to download](https://jampack.vercel.app/)

> ✅ **100+ Users have downloaded JamPack**  
> According to Google Analytics, JamPack has already helped over a hundred users streamline multi-file workflows for AI tools.

---

## 🚀 Why JamPack?

AI models like GPT-4, Claude 3, and Gemini 1.5 have **context windows**, **file limits**, and **upload caps**:

> • ChatGPT allows up to **10** files per upload and caps each text file at 2 M tokens[^gpt_files]  
> • Claude lets you attach **20** files per chat and still has a 200 K-token window[^claude_files][^claude_tokens]  
> • Even “long-context” models such as Gemini 1.5 (1-2 M tokens)[^gemini_tokens] or GPT-4o (128 K tokens)[^gpt_context] can choke on large multi-file projects.  
> JamPack flattens your project into a single, well-labeled text file, keeping filenames as in-file headers so the AI understands each part.


**JamPack solves this.** It flattens your project into one `.txt` file while preserving:
- **File structure**
- **File names as readable headers**
- **Language identity**

So AI can still understand what's what — with **zero confusion.**

---

## ✨ Features

-  **Drag & Drop** multiple source files
-  **Reorder** files with simple drag handles
-  **Exclude unwanted files** individually
-  **One-click export** to a `.txt` file (named automatically)
-  **Streaming-based merge system**
   Efficient even with hundreds or thousands of files
- Handles large content (gigabyte-scale) with **minimal memory**
-  **Output file is auto-copied to clipboard**
-  **Choose save location** (default: Downloads folder)
-  **Instant folder opening** after merge
-  **Rejects unsupported file types** (e.g., images, binaries)

---

## ⚙️ How It Works (Tech Details)

JamPack uses a **streaming I/O model** under the hood:

- Instead of reading all files into memory at once, it uses `FileHandle` to process each file **in chunks** (32KB at a time).
- This chunked reading and writing prevents memory crashes on large merges.
- Files are prefixed and suffixed with Markdown-style code blocks (` ```filename `) for readability.
- The final merged `.txt` is stored efficiently and copied to your clipboard.
- You can also **automatically open** the save folder after export.

This makes JamPack ideal for merging:
- Large repositories
- Notebook exports
- Educational codebases
- Long chat history logs

---

## 📄 Supported Languages

JamPack supports virtually all common code formats:

HTML, CSS, JavaScript, TypeScript, Python, Swift, Java, C, C++, C#, Go, Rust, PHP, Ruby, Kotlin, Lua, SQL, Perl, Scala, Sass, Vue, and more.

> ⚠️ Unsupported files like images, videos, or binaries are safely rejected.

---

## 💾 Installation

1. Download **[JamPack.dmg](https://jampack.vercel.app/)**
2. Open the `.dmg`
3. Drag **JamPack** into your **Applications** folder
4. Launch from **Launchpad** or **Spotlight**

---

## 🖥 Requirements

- macOS 12 (Monterey) or later

---

## 📜 License

MIT

---

[^gpt_files]: OpenAI Help Center – “File uploads FAQ”  
<https://help.openai.com/en/articles/8555545-file-uploads-faq>

[^gpt_context]: OpenAI API Docs – “GPT-4o” model card  
<https://platform.openai.com/docs/models/gpt-4o>

[^claude_files]: Anthropic Help Center – “What kinds of documents can I upload to Claude.ai?”  
<https://support.anthropic.com/en/articles/8241126-what-kinds-of-documents-can-i-upload-to-claude-ai>

[^claude_tokens]: Anthropic Help Center – “Maximum prompt length”  
<https://support.anthropic.com/en/articles/7996856-what-is-the-maximum-prompt-length>

[^gemini_tokens]: Google AI Developers – “Long context”  
<https://ai.google.dev/gemini-api/docs/long-context>
