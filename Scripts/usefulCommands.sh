for file in *_*; do rm *.err *.out $file/_cmdline $file/_filelist $file/_sitecheck $file/*.tgz; done

for file in *_*/output_data/*;do sbatch $file; done

# section to generate the analysis file containing the processed data for all the samples

for file in V*_*; do mkdir ../analysisFiles/$file; done
for file in V*_*; do cp $file/output_data/$file/outs/web_summary.html ../analysisFiles/$file; done
for file in V*_*; do cp $file/output_data/$file/outs/filtered_feature_bc_matrix.h5 ../analysisFiles/$file; done
for file in V*_*; do cp $file/output_data/$file/outs/spatial/tissue_hires_image.png ../analysisFiles/$file; done
for file in V*_*; do cp $file/output_data/$file/outs/spatial/scalefactors_json.json ../analysisFiles/$file; done
for file in V*_*; do cp $file/output_data/$file/outs/spatial/tissue_positions_list.csv ../analysisFiles/$file; done


