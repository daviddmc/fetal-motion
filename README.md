# fetal-motion

fetal motion analysis using 3D keypoint data

## data

The input data are the 3D coordinates of each keypoint in each frame.
The keypoint of a subject should be in a `.mat` file.

```
data
├── subject1.mat
├── subject2.mat
├── ...
```

Each `.mat` file has an array `joint_coord` with shape of `(T, 3, K)`,
where `T` is the number of frames,
`3` is the three dimensions (x, y, z),
and `K` is the number of different keypoints, which is 15 in our work.

Information of each subject is stored in `data.xlsx`, which consists of 4 columns.

```
name: a unique name of the subject, which should be matched with the file name in ./data
duration: duration of the scan in min
GA_week 
GA_day
```

## example

Run `example.m` for an exmaple. The results will be stored in `results.xlsx`.

## citation

```
@article{vasung2022cross,
  title={Cross-sectional Observational Study of Typical in-utero Fetal Movements using Machine Learning},
  author={Vasung, Lana and Xu, Junshen and Abaci-Turk, Esra and Zhou, Cindy and Holland, Elizabeth and Barth, William H and Barnewolt, Carol and Connolly, Susan and Estroff, Judy and Golland, Polina and others},
  journal={Developmental Neuroscience},
  publisher={Karger Publishers}
}
```
