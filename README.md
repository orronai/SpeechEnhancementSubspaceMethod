<h1 align="center">Subspace Method for RTF Estimation and Speech Enhancement Using Riemannian Geometry</h1>

<p align="center">
  <img src="./assets/Spectrograms.jpg">
</p>

<p align="center">
    Or Ronai: <a href="https://www.linkedin.com/in/orronai/">LinkedIn</a>, <a href="https://github.com/orronai">GitHub</a> •
    Amitay Bar: <a href="https://www.linkedin.com/in/amitay-bar-1710ba91/">LinkedIn</a>, <a href="https://github.com/amitaybar">GitHub</a>
  <br>
    Ronen Talmon: <a href="https://www.linkedin.com/in/ronen-talmon-2080271/">LinkedIn</a>, <a href="https://github.com/RonenTalmonLab">GitHub</a> •
    Israel Cohen: <a href="https://www.linkedin.com/in/israel-cohen-8b50a143/">LinkedIn</a>, <a href="https://github.com/IsraelCohenLab">GitHub</a>
</p>

## Background
We propose a new subspace method for signal enhancement that involves estimating the relative transfer function (RTF).
Specifically, we propose an RTF estimator that relies on both the sample correlation matrix, which is typically used in the absence of interfering sources, and the Riemannian mean of correlation matrices, which was recently shown to excel in rejecting interfering sources.
We begin by considering the Riemannian mean-based RTF estimator, and then apply subspace filtering by projecting it onto the space of the principal components of the sample correlation matrices.
We incorporate the proposed RTF estimation into the minimum variance distortionless response (MVDR) beamformer and evaluate its performance under various challenging acoustic scenarios.

## Files In The Repository
|File name| Purpsoe|
|---------------------------------------------------------------|-----------------------------------------------------------------|
|`EstimateSignalSubspace.m`| Code runs all the simulations and plots the graphs|
| `functions/*.m`| Functions used in the simulations for code clarity|
| `simulations/*.m`| The simulations presented in the paper|
| `plots/*.m`| Plot functions for simulations|
| `rir_generator_install.sh`| Installing the RIR generator|

* We note that the speech examples were tested for the scenario examined in the paper.

## Installation
1. Clone the repository.
2. Install the RIR generator using the `rir_generator_install.sh` script.
3. Alternatively, install it using the instructions appear in <a href="https://www.audiolabs-erlangen.de/fau/professor/habets/software/rir-generator">AudioLabs - RIR Generator</a>.
4. Download the <a href="https://www.ldc.upenn.edu/">TIMIT Acoustic-Phonetic Continuous Speech Corpus</a>.

### Prerequisites
The code was tested using Matlab 2022a on Windows 10 and Matlab 2024b on macOS 15.6.1.

### Run The Simulations
To run the simulations and create the graphs that appear in the paper, run the `EstiamteSignalSubspace.m` file.

## Sources
* [TIMIT Acoustic-Phonetic Continuous Speech Corpus](https://catalog.ldc.upenn.edu/LDC93S1).
* [Image method for efficiently simulating small-room acoustics](https://www.audiolabs-erlangen.de/fau/professor/habets/software/rir-generator).
* [RTF Estimation Using Riemannian Geometry for Speech Enhancement in the Presence of Interferences](https://github.com/orronai/SpeechEnhancementRiemannianGeometry).

