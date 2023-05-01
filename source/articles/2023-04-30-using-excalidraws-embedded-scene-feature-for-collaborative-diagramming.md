---
title: "Using Excalidraw's Embedded Scene Feature for Collaborative Diagramming"

description: "Learn about Excalidraw's embedded scene feature, which allows you to save diagrams as PNG or SVG files while retaining the ability to modify them within Excalidraw. In this post, we'll explore how the embedded scene feature works, its benefits, and some potential gotchas to watch out for."

tags:
- Tool
- Diagramming
- Excalidraw

pull_image: "/images/2023-04-30-using-excalidraws-embedded-scene-feature-for-collaborative-diagramming/excalidraw-export.png"
pull_image_attribution: 'A screenshot of the Excalidraw export modal with the embed scene tooltip shown.'
---

As a software developer, creating and modifying diagrams is an essential part of the job. [Excalidraw](https://excalidraw.com/) is a diagramming tool that offers flexibility, speed, and collaborative features for both personal and work scenarios.

But what sets Excalidraw apart is its [embedded scene feature](https://twitter.com/excalidraw/status/1316001446043750400), which started out as an [idea captured in a GitHub Issue](https://github.com/excalidraw/excalidraw/issues/414). This feature allows diagrams to be saved as artifacts like PNG or SVG files while retaining the ability to modify them within Excalidraw. When exporting a PNG or SVG, the Excalidraw scene data is embedded inside the file artifact. This means that you can open the file in Excalidraw and continue modifying the diagram.

## Benefits of Embedded Scene

The embedded scene feature simplifies the process of modifying diagrams by eliminating the need for separate image and JSON data files. This is particularly useful in collaborative settings, as the file can be under version control. The file can be easily committed to a Git repository and viewed in rendered documentation sites.

Another added bonus is the availability of the [Excalidraw extension for VS Code](https://marketplace.visualstudio.com/items?itemName=pomdtr.excalidraw-editor). This enables modification of the file within the IDE editor, allowing for easy in-place changes to architecture and flow diagrams.

## Potential Challenges

There are a few challenges to keep in mind when working with the embedded scene feature. If the file with the embedded scene data is compressed or minified, the scene data is lost. This means that files committed to a repository should not be compressed or minified so they can continue to be editable.

## Comparison to Other Diagramming Tools

Excalidraw offers a simpler and more straightforward approach to diagramming when compared to other tools like [Mermaid](https://mermaid.js.org/) or markup-related tools (in my opinion). While tools like [Miro](https://miro.com/) or [Figma](https://www.figma.com/) offer powerful collaboration features, they don't integrate well into a repository setting. Excalidraw's embedded scene feature keeps diagrams close to the code, simplifying the modification process.

## Conclusion

Excalidraw's embedded scene feature streamlines the creation and modification of diagrams. Its simplicity and integration with repositories make it a great tool for software developers. While there are potential challenges to consider, the benefits of the embedded scene feature outweigh them. Whether working solo or in a team, Excalidraw can make diagramming more enjoyable and efficient.
