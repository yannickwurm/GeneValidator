require 'minitest'
require 'minitest/autorun'
require "yaml"
require 'fileutils'
require 'validation'
require 'genevalidator/blast'
require 'genevalidator/validation_length_cluster'
require 'genevalidator/validation_length_rank'
require 'genevalidator/validation_blast_reading_frame'
require 'genevalidator/validation_gene_merge'
require 'genevalidator/validation_duplication'
require 'genevalidator/validation_open_reading_frame'
require 'genevalidator/validation_alignment'

class ValidateOutput < Minitest::Test

  filename_prot = "test/test_files/all_validations_prot/all_validations_prot"
  filename_prot_fasta = "#{filename_prot}.fasta"
  filename_prot_xml = "#{filename_prot}.xml"
  filename_prot_tab = "#{filename_prot}.tab"
  filename_prot_yaml = "#{filename_prot_fasta}.yaml"
  filename_prot_html = "#{filename_prot_fasta}.html"
  filename_prot_raw = "#{filename_prot_xml}.raw_seq"
  filename_prot_out_xml = "#{filename_prot_xml}.out"
  filename_prot_out_tab = "#{filename_prot_tab}.out"
  filename_prot_raw_idx = "#{filename_prot_raw}.idx"

  filename_mrna = "test/test_files/all_validations_mrna/all_validations_mrna"
  filename_mrna_fasta = "#{filename_mrna}.fasta"
  filename_mrna_xml = "#{filename_mrna}.xml"
  filename_mrna_tab = "#{filename_mrna}.tab"
  filename_mrna_yaml = "#{filename_mrna_fasta}.yaml"
  filename_mrna_html = "#{filename_mrna_fasta}.html"
  filename_mrna_raw = "#{filename_mrna_xml}.raw_seq"
  filename_mrna_out_xml = "#{filename_mrna_xml}.out"
  filename_mrna_out_tab = "#{filename_mrna_tab}.out"
  filename_mrna_raw_idx = "#{filename_mrna_raw}.idx"

  validations = ["lenc", "lenr", "dup", "orf", "align"]


  describe "Protein dataset" do
    it "xml and tabular inputs give the same output" do

      original_stdout = $stdout.clone
      $stdout.reopen(filename_prot_out_xml, "w")

      begin
        FileUtils.rm_rf(filename_prot_html)
        rescue Error
      end

      b = Validation.new(filename_prot_fasta, validations, nil, filename_prot_xml, "swissprot -remote", filename_prot_raw, 1, 1, false, false)
      b.validation
      $stdout.reopen original_stdout
      $stdout.reopen(filename_prot_out_tab, "w")

      begin
        FileUtils.rm_rf(filename_prot_html)
        rescue Error
      end

      b = Validation.new(filename_prot_fasta,
                         validations,
                         "qseqid sseqid sacc slen qstart qend sstart send length qframe pident evalue",
                         filename_prot_tab,
                         "swissprot -remote",
                         filename_prot_raw,
                         1, 1, false, false)
      b.validation
      $stdout.reopen original_stdout

      diff = FileUtils.compare_file(filename_prot_out_xml, filename_prot_out_tab)

      File.delete(filename_prot_out_xml)
      File.delete(filename_prot_out_tab)
      File.delete(filename_prot_yaml)
      File.delete(filename_prot_raw_idx)

      FileUtils.rm_rf(filename_prot_html)

      assert_equal(true, diff)

    end
  end

  describe "mRNA dataset" do
    it "xml and tabular inputs give the same output" do

      original_stdout = $stdout.clone
      $stdout.reopen(filename_mrna_out_xml, "w")

      begin
        FileUtils.rm_rf(filename_mrna_html)
        rescue Error
      end

      b = Validation.new(filename_mrna_fasta, validations, nil, filename_mrna_xml, "swissprot -remote", filename_mrna_raw, 1, 1, false, false)
      b.validation
      $stdout.reopen original_stdout
      $stdout.reopen(filename_mrna_out_tab, "w")

      begin
        FileUtils.rm_rf(filename_mrna_html)
        rescue Error
      end

      b = Validation.new(filename_mrna_fasta,
                         validations,
                         "qseqid sseqid sacc slen qstart qend sstart send length qframe pident evalue",
                         filename_mrna_tab,
                         "swissprot -remote",
                         filename_mrna_raw,
                         1, 1, false, false)
      b.validation
      $stdout.reopen original_stdout

      diff = FileUtils.compare_file(filename_mrna_out_xml, filename_mrna_out_tab)

      File.delete(filename_mrna_out_xml)
      File.delete(filename_mrna_out_tab)
      File.delete(filename_mrna_yaml)
      File.delete(filename_mrna_raw_idx)

      FileUtils.rm_rf(filename_mrna_html)

      assert_equal(true, diff)
    end
  end
end
