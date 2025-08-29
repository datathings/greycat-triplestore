Here’s a regenerated and improved **README.md**, with your requested addition about the `demo_data` option clearly integrated and the overall structure polished for readability:

````markdown
# Greycat Triple-Store Demo (with DBpedia)

A minimal, end-to-end demo that downloads a [DBpedia](https://www.dbpedia.org/) snapshot, imports it into **Greycat**, and lets you explore the data as a knowledge graph.  
For quick testing, a lightweight **demo dataset** is also included (see [Use demo data instead of DBpedia](#use-demo-data-instead-of-dbpedia)).

---

## Prerequisites

* **bash**, **curl**, **wget**
* **gzip** and **bzip2** (for `.gz` / `.bz2` files)
  * Ubuntu/Debian:  
    ```bash
    sudo apt-get install -y gzip bzip2
    ```
* 76 GB of free disk space in `./data/` (DBpedia is large)
* Around 300 GB of free disk space for `./gcdata/` (Greycat graph database)
---

## 1) Get the DBpedia data

This fetches the **latest-core** DBpedia files, puts them in `./data/`, and auto-decompresses archives:

```bash
./download.sh
````

> 💡 Tip: Safe to rerun — it resumes partial downloads and only (re)extracts missing files.

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
GREYCAT_CACHE=8000

# Number of worker threads
GREYCAT_WORKERS=4
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
👉 **[http://localhost:8080/explorer/](http://localhost:8080/explorer/)**

---

## Use demo data instead of DBpedia

If you don’t want to download the full DBpedia dataset, you can use the lightweight **`demo_data/`** folder included in the repo.

To switch:

1. Open `project.gcl`.
2. Comment out the DBpedia import line:

   ```gcl
   // TripleStoreService::importDir("./data");
   ```
3. Uncomment the demo dataset line:

   ```gcl
   TripleStoreService::importDir("./demo_data");
   ```

Then continue with the import step (`greycat run import`) — the graph will be built from the demo dataset.

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
├─ src/                 # Greycat triple-store graph database library
├─ data/                # Decompressed DBpedia files here
├─ demo_data/           # Small sample dataset for quick testing
├─ project.gcl          # Greycat main entry point (edit for dataset choice)
├─ .env                 # Greycat settings (cache, workers)
├─ download.sh          # Fetches DBpedia core & auto-decompresses into ./data
└─ ...
```

---

## TL;DR

```bash
# Option A: Full DBpedia
./download.sh
curl -fsSL https://get.greycat.io/install.sh | bash -s stable
greycat install
echo -e "GREYCAT_CACHE=400000\nGREYCAT_WORKERS=83" > .env
greycat run import
greycat serve --user=1
# → open http://localhost:8080/explorer/

# Option B: Demo dataset
# (edit project.gcl as described above before import)
curl -fsSL https://get.greycat.io/install.sh | bash -s stable
greycat install
echo -e "GREYCAT_CACHE=400000\nGREYCAT_WORKERS=83" > .env
greycat run import
greycat serve --user=1
# → open http://localhost:8080/explorer/
```
