# Greycat Triple-Store Demo (with DBpedia)

A minimal, end-to-end demo that downloads a DBpedia snapshot, imports it into **Greycat**, and lets you explore the data as a knowledge graph.

## Prerequisites

* **bash**, **curl**, **wget**
* **gzip** and **bzip2** (for `.gz` / `.bz2` files)

  * Ubuntu/Debian: `sudo apt-get install -y gzip bzip2`
* A few GB of free disk space in `./data` (DBpedia is large)

---

## 1) Get the data

This fetches the [DBpedia](https://www.dbpedia.org/) “latest-core” files, puts them in `./data/`, and auto-decompresses archives.

```bash
./download.sh
```

> Tip: rerun safely; it resumes partial downloads and only (re)extracts needed files.

---

## 2) Install Greycat CLI

```bash
curl -fsSL https://get.greycat.io/install.sh | bash -s stable
```

Add Greycat to your `PATH` if needed (the installer prints instructions).

---

## 3) Install the project’s Greycat libraries

From the project root:

```bash
greycat install
```

---

## 4) Configure resources

Create or edit a `.env` file in the project root:

```env
# Cache size for Greycat (tune for your machine & dataset size)
GREYCAT_CACHE=400000

# Number of worker threads
GREYCAT_WORKERS=83
```

**Guidance**

* Increase `GREYCAT_CACHE` if you have plenty of RAM.
* Set `GREYCAT_WORKERS` near (but not far above) your CPU thread count.

---

## 5) Import the dataset

```bash
greycat run import
```

This step reads the decompressed DBpedia files from `./data/` (e.g., `.nt`, `.ttl`, etc.) and builds the graph in Greycat’s storage.

---

## 6) Explore the graph

Start the local server:

```bash
greycat serve --user=1
```

Then open the Explorer UI:
**[http://localhost:8080/explorer/](http://localhost:8080/explorer/)**

---

## Handy checks & tips

**Verify downloaded files**

```bash
ls -lh ./data | head
```

**Peek inside an RDF N-Triples file**

```bash
head -n 5 ./data/*.nt
```

**Count lines (rough proxy for triple count in `.nt`)**

```bash
wc -l ./data/*.nt
```

---

## Project layout (expected)

```
.
├─ src/                 # Greycat triple store graph database library
├─ data/                # Decompressed DBpedia files here
├─ project.gcl          # Greycat main entry point
├─ .env                 # Greycat settings (cache, workers)
├─ download.sh          # Fetches DBpedia core & auto-decompresses into ./data
└─ ...
```

---

## TL;DR

```bash
./download.sh
curl -fsSL https://get.greycat.io/install.sh | bash -s stable
greycat install
echo -e "GREYCAT_CACHE=400000\nGREYCAT_WORKERS=83" > .env
greycat run import
greycat serve --user=1
# → open http://localhost:8080/explorer/
```
