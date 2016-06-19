require 'icalendar'

cal = Icalendar::Calendar.new

[
  {
    dtstart: [25, 9, 15],
    dtend: [25, 10, 15],
    speaker: '王永雄',
    title: 'Dissecting the regulatory elements of the genome',
  },
  {
    dtstart: [25, 10, 35],
    dtend: [25, 11, 10],
    speaker: '李霞',
    title: 'Precision medical and biomedical big data',
  },
  {
    dtstart: [25, 11, 10],
    dtend: [25, 11, 45],
    speaker: '姜涛',
    title: 'Transcript-based differential expression analysis for population RNA-seq data',
  },
  {
    dtstart: [25, 11, 45],
    dtend: [25, 12, 20],
    speaker: '李婧翌',
    title: 'NMFP: a non-negative matrix factorization based preselection method to increase accuracy of identifying mRNA isoforms from RNA-seq data',
  },
  {
    dtstart: [25, 14, 00],
    dtend: [25, 14, 35],
    speaker: '吴国宝',
    title: 'Some regularization models for data classification',
  },
  {
    dtstart: [25, 14, 35],
    dtend: [25, 15, 10],
    speaker: '黄德双',
    title: 'Modeling and predicting PPI networks based on machine learning techniques',
  },
  {
    dtstart: [25, 15, 10],
    dtend: [25, 15, 45],
    speaker: '朱山风',
    title: 'DrugE-Rank: improving drug-target interaction prediction of new candidate drugs or targets by ensemble learning to rank',
  },
  {
    dtstart: [25, 16, 10],
    dtend: [25, 16, 45],
    speaker: '李雷',
    title: 'BAUM: a DNA assembler by adaptive unique mapping and local overlap-layout-consensus',
  },
  {
    dtstart: [25, 16, 45],
    dtend: [25, 17, 20],
    speaker: '张绍武',
    title: 'DBH: a de Bruijn graph-based heuristic method for clustering large-scale 16S rRNA sequences into OTUs',
  },
  {
    dtstart: [26, 9, 00],
    dtend: [26, 9, 35],
    speaker: '许东',
    title: 'Application of big data analytics in precision medicine and crop molecular breeding',
  },
  {
    dtstart: [26, 9, 35],
    dtend: [26, 10, 10],
    speaker: '高琳',
    title: 'Network based methods for cancer related pattern mining',
  },
  {
    dtstart: [26, 10, 45],
    dtend: [26, 11, 15],
    speaker: '沈百荣',
    title: 'Bioinformatics model for key players and their molecular functions in prostate cancer',
  },
  {
    dtstart: [26, 11, 15],
    dtend: [26, 11, 50],
    speaker: '张世华',
    title: 'Discovery of mutated driver pathways in cancer',
  },
  {
    dtstart: [26, 13, 30],
    dtend: [26, 14, 05],
    speaker: '李梢',
    title: '网络药理学：从计算到发现的药物系统性研究方法',
  },
  {
    dtstart: [26, 14, 05],
    dtend: [26, 14, 40],
    speaker: '刘娟',
    title: '基于数据驱动的药物重定位方法研究',
  },
  {
    dtstart: [26, 14, 40],
    dtend: [26, 15, 15],
    speaker: '张淑芹',
    title: 'Drug-target interaction prediction by integrating multiview network data',
  },
].each do |data|
  cal.event do |e|
    e.dtstart     = DateTime.civil(2016, 6, data[:dtstart][0], data[:dtstart][1], data[:dtstart][2])
    e.dtend       = DateTime.civil(2016, 6, data[:dtend][0], data[:dtend][1], data[:dtend][2])
    e.summary     = "[#{data[:speaker]}]#{data[:title]}[生物大数据与数据挖掘研讨会]"
    e.location    = '北京市海淀区中关村东路 55 号中科院数学与系统科学研究院思源楼一层报告厅'
  end
end

File.open('export.ics', 'w').puts cal.to_ical
