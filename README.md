# [JamPack](https://jampack.vercel.app/)
![JamPack icon](https://github.com/user-attachments/assets/cdef9412-651b-43f5-92a0-139b175c7d83)

[click to download](https://jampack.vercel.app/downloads/JamPack.dmg)

**JamPack** is a lightweight macOS utility that bundles any number of code files into **one** `.txt` so you can feed them to AI assistants (or archive them) without hitting UI-level file-upload caps or model context limits.

> **Why does this matter?**  
> • ChatGPT allows up to **10** files per upload and caps each text file at 2 M tokens[^gpt_files]  
> • Claude lets you attach **20** files per chat and still has a 200 K-token window[^claude_files][^claude_tokens]  
> • Even “long-context” models such as Gemini 1.5 (1-2 M tokens)[^gemini_tokens] or GPT-4o (128 K tokens)[^gpt_context] can choke on large multi-file projects.  
> JamPack flattens your project into a single, well-labeled text file, keeping filenames as in-file headers so the AI understands each part.

## Features
- **Drag & Drop** multiple source files
- Language-aware icons (JS, TS, Python, …)
- Re-order files by dragging
- Remove individual files before merging
- One-click export to a properly-named `.txt`
- Rejects unsupported types (images, binaries)

## Supported Languages
HTML, CSS, JavaScript, TypeScript, Python, Swift, Java, C, C++, C#, Go, Rust, PHP, Ruby, Kotlin, Lua, SQL, Perl, Scala, Sass, Vue, and many other code files.

## Installation
1. Download **[JamPack.dmg](https://jampack.vercel.app/downloads/JamPack.dmg)**  
2. Open the `.dmg`  
3. Drag **JamPack** into **Applications**  
4. Launch **JamPack** from Launchpad or Spotlight

## Requirements
- macOS 12 Monterey or later

## License
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
